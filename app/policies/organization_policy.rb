class OrganizationPolicy < ApplicationPolicy
  def show?
    true
  end

  def join?
    user.present? && !user.member_of?(record)
  end

  def admin?
    user&.admin_of?(record)
  end

  def admin_or_manager?
    user&.admin_of?(record) || user&.manager_of?(record)
  end

  def manage_members?
    user&.admin_of?(record)
  end

  def create?
    user&.adult? && user&.age_verified?
  end

  def update?
    user&.admin_of?(record) || user&.admin?
  end

  def destroy?
    user&.owner_of?(record) || user&.admin?
  end

  def update_role?
    user&.admin_of?(record)
  end

  def approve_membership?
    user&.admin_of?(record)
  end

  def reject_membership?
    user&.admin_of?(record)
  end
end 