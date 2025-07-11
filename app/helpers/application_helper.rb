module ApplicationHelper
  def role_badge_class(role)
    case role.to_s
    when 'admin'
      'bg-red-100 text-red-800'
    when 'manager'
      'bg-blue-100 text-blue-800'
    when 'employee'
      'bg-green-100 text-green-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
