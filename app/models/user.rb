class User < ApplicationRecord
  has_secure_password

  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :created_projects, class_name: 'Project', foreign_key: 'created_by_id'

  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :date_of_birth, presence: true

  before_save :downcase_email

  def member_of?(organization)
    organization_memberships.where(organization: organization, status: 'approved').exists?
  end

  def admin_of?(organization)
    organization_memberships.where(organization: organization, role: 'admin', status: 'approved').exists?
  end

  def manager_of?(organization)
    organization_memberships.where(organization: organization, role: ['admin', 'manager'], status: 'approved').exists?
  end

  def pending_membership?(organization)
    organization_memberships.where(organization: organization, status: 'pending').exists?
  end

  def role_in(organization)
    membership = organization_memberships.find_by(organization: organization, status: 'approved')
    membership&.role
  end

  def approved_organizations
    Organization.joins(:organization_memberships)
                .where(organization_memberships: { user_id: id, status: 'approved' })
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def global_admin?
    email == 'admin@example.com'
  end

  def age
    return 0 unless date_of_birth
    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
  end

  def minor?
    age < 18
  end

  def adult?
    age >= 18
  end

  def age_group
    case age
    when 0..12 then 'child'
    when 13..17 then 'teen'  
    when 18..64 then 'adult'
    else 'senior'
    end
  end

  private

  def downcase_email
    self.email = email.downcase if email
  end

  def password_required?
    new_record? || password.present?
  end
end
