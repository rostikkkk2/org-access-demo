class UserPolicy < ApplicationPolicy
  def show?
    user == record || user&.admin?
  end

  def update?
    user == record || user&.admin?
  end

  def destroy?
    user&.admin? && user != record
  end
end 