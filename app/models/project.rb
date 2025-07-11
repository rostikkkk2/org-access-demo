class Project < ApplicationRecord
  belongs_to :organization
  belongs_to :created_by, class_name: 'User'

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true
  validates :status, inclusion: { in: %w[active completed archived] }

  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }

  def can_be_edited_by?(user)
    return false unless user
    
    created_by == user || 
    user.admin_of?(organization) || 
    user.manager_of?(organization)
  end

  def can_be_deleted_by?(user)
    return false unless user
    
    created_by == user || user.admin_of?(organization)
  end

  def overdue?
    deadline.present? && deadline < Time.current && status == 'active'
  end

  def status_badge_class
    case status
    when 'active' then 'bg-green-100 text-green-800'
    when 'completed' then 'bg-blue-100 text-blue-800'
    when 'archived' then 'bg-gray-100 text-gray-800'
    end
  end
end 