OrganizationMembership.destroy_all
Organization.destroy_all
User.destroy_all

google = Organization.create!(
  name: 'Google',
  description: 'Technology company focusing on search engine technology, online advertising, cloud computing, computer software, quantum computing, e-commerce, artificial intelligence, and consumer electronics.'
)

microsoft = Organization.create!(
  name: 'Microsoft',
  description: 'Multinational technology corporation that produces computer software, consumer electronics, personal computers, and related services.'
)

startup = Organization.create!(
  name: 'TechStartup Inc',
  description: 'Innovative startup working on AI-powered solutions for modern businesses.'
)

admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  date_of_birth: Date.new(2000, 1, 1)
)

john = User.create!(
  email: 'john@gmail.com',
  password: 'password123',
  first_name: 'John',
  last_name: 'Doe',
  date_of_birth: Date.new(2001, 1, 1)
)

sarah = User.create!(
  email: 'sarah@gmail.com',
  password: 'password123',
  first_name: 'Sarah',
  last_name: 'Smith',
  date_of_birth: Date.new(1990, 1, 1)
)

OrganizationMembership.create!(
  user: admin,
  organization: google,
  role: 'admin',
  status: 'approved'
)

OrganizationMembership.create!(
  user: john,
  organization: google,
  role: 'employee',
  status: 'pending',
  message: 'I am a Frontend developer with 5 years of experience'
)

OrganizationMembership.create!(
  user: sarah,
  organization: microsoft,
  role: 'manager',
  status: 'approved'
)

puts "Created #{User.count} users"
puts "Created #{Organization.count} organizations"
puts "Created #{OrganizationMembership.count} memberships"
