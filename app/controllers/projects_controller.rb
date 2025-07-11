class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_organization
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete]

  def index
    @projects = Project.where(organization: @organization).order(created_at: :desc)
  end

  def show
    authorize @project
  end

  def new
    @project = @organization.projects.build
    authorize @project
  end

  def create
    @project = @organization.projects.build(project_params)
    @project.created_by = current_user
    authorize @project

    if @project.save
      flash[:success] = 'Project created successfully!'
      redirect_to organization_project_path(@organization, @project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project
    
    if @project.update(project_params)
      flash[:success] = 'Project updated successfully!'
      redirect_to organization_project_path(@organization, @project)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @project
    
    @project.destroy
    flash[:success] = 'Project deleted successfully!'
    redirect_to organization_projects_path(@organization)
  end

  def complete
    authorize @project, :complete?
    
    @project.update(status: 'completed')
    flash[:success] = 'Project marked as completed!'
    redirect_to organization_project_path(@organization, @project)
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_project
    @project = @organization.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :deadline)
  end
end 