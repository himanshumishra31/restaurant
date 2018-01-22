Branch.find_or_create_by(name: 'Patel Nagar') do |branch|
  branch.opening_time = '10:00:00'
  t.closing_time = '22:00:00'
  t.default = true
end
