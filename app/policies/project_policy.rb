class ProjectPolicy < ApplicationPolicy
  def index?
    user&.member_of?(record.organization)
  end

  def show?
    user&.member_of?(record.organization)
  end

  def create?
    return false unless user&.member_of?(record.organization)
    
    user_role = user.role_in(record.organization)
    record.organization.can_create_projects?(user_role)
  end

  def new?
    create?
  end

  def update?
    record.can_be_edited_by?(user)
  end

  def edit?
    update?
  end

  def destroy?
    record.can_be_deleted_by?(user)
  end

  def complete?
    update?
  end
end 