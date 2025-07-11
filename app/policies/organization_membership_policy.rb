class OrganizationMembershipPolicy < ApplicationPolicy
  def update_role?
    return false unless user.present?
    user.admin_of?(record.organization) && user != record.user
  end

  def destroy?
    return false unless user.present?
    user.admin_of?(record.organization) && user != record.user
  end
end 