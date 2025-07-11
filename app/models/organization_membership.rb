class OrganizationMembership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  # Валидации
  validates :status, inclusion: { in: %w[pending approved rejected] }
  validates :role, inclusion: { in: %w[admin manager employee] }
  validates :user_id, uniqueness: { scope: :organization_id }

  # Скоупы
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  # Методы для изменения статуса
  def approve!
    update!(status: 'approved')
  end

  def reject!
    update!(status: 'rejected')
  end

  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  # Методы для проверки ролей
  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def employee?
    role == 'employee'
  end

  # Может ли управлять другими участниками
  def can_manage_members?
    admin? || manager?
  end

  # Красивое название роли
  def role_name
    role.capitalize
  end
end