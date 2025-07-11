class OrganizationsController < ApplicationController
  before_action :require_login
  before_action :set_organization, only: [:show, :join, :admin, :approve_membership, :reject_membership, :update_member_role, :remove_member]

  def index
    @organizations = Organization.all.order(:name)
    
    if current_user
      @my_organizations = Organization.joins(:organization_memberships)
                                    .where(organization_memberships: { user_id: current_user.id, status: 'approved' })
      @pending_requests = current_user.organization_memberships.pending.includes(:organization)
    end
  end

  def show
    authorize @organization if current_user
    @current_membership = current_user&.organization_memberships&.find_by(organization: @organization)
    @members = @organization.approved_memberships.includes(:user).order(:role, 'users.first_name')
  end

  def join
    authorize @organization

    @membership = @organization.organization_memberships.build(
      user: current_user,
      message: params[:message],
      status: 'pending',
      role: 'employee'
    )

    if @membership.save
      flash[:success] = 'Your membership request has been submitted for review.'
    else
      flash[:alert] = 'Unable to submit request. Please try again.'
    end

    redirect_to @organization
  end

  def admin
    authorize @organization, :admin_or_manager?
    
    @pending_requests = @organization.pending_memberships
                                   .includes(:user)
                                   .order(:created_at)
    @members = @organization.approved_memberships
                           .includes(:user)
                           .order(:role, 'users.first_name')
  end

  def approve_membership
    authorize @organization, :approve_membership?
    @membership = @organization.organization_memberships.find(params[:membership_id])
    
    if @membership.approve!
      flash[:success] = "#{@membership.user.full_name} has been approved!"
    else
      flash[:alert] = 'Unable to approve membership.'
    end

    redirect_to admin_organization_path(@organization)
  end

  def reject_membership
    authorize @organization, :reject_membership?
    @membership = @organization.organization_memberships.find(params[:membership_id])
    
    if @membership.reject!
      flash[:success] = "#{@membership.user.full_name} has been rejected."
    else
      flash[:alert] = 'Unable to reject membership.'
    end

    redirect_to admin_organization_path(@organization)
  end

  def update_member_role
    @membership = @organization.organization_memberships.find(params[:membership_id])
    authorize @membership, :update_role?
    
    old_role = @membership.role
    new_role = params[:role]
    
    if @membership.update(role: new_role)
      flash[:success] = "#{@membership.user.full_name} role updated from #{old_role} to #{new_role}"
    else
      flash[:alert] = 'Unable to update role.'
    end

    redirect_to admin_organization_path(@organization)
  end

  def remove_member
    @membership = @organization.organization_memberships.find(params[:membership_id])
    authorize @membership, :destroy?
    
    user_name = @membership.user.full_name
    
    if @membership.destroy
      flash[:success] = "#{user_name} has been removed from #{@organization.name}"
    else
      flash[:alert] = 'Unable to remove member.'
    end

    redirect_to admin_organization_path(@organization)
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end