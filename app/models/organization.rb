class Organization < ApplicationRecord
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :pending_memberships, -> { where(status: 'pending') }, 
           class_name: 'OrganizationMembership'
  has_many :approved_memberships, -> { where(status: 'approved') }, 
           class_name: 'OrganizationMembership'
  has_many :members, through: :approved_memberships, source: :user
  has_many :projects, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def total_members
    approved_memberships.count
  end

  def pending_requests_count
    pending_memberships.count
  end

  def admins
    members.joins(:organization_memberships)
           .where(organization_memberships: { organization: self, role: 'admin', status: 'approved' })
  end

  def managers
    members.joins(:organization_memberships)
           .where(organization_memberships: { organization: self, role: 'manager', status: 'approved' })
  end

  def employees
    members.joins(:organization_memberships)
           .where(organization_memberships: { organization: self, role: 'employee', status: 'approved' })
  end

  def role_stats
    approved_memberships.group(:role).count
  end

  def can_join?(user)
    return false if user.member_of?(self)
    return false if user.pending_membership?(self)
    true
  end

  def to_param
    id.to_s
  end

  def can_create_projects?(user_role)
    %w[admin manager].include?(user_role)
  end

  def active_projects_count
    projects.active.count
  end
end