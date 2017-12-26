begin
  namespace :admin do
    task :new => :environment do
      puts "Hi Admin. Please Enter Your name"
      name = STDIN.gets.chomp
      puts "Enter an email address:"
      email = STDIN.gets.chomp
      puts "Enter a password:"
      password = STDIN.gets.chomp
      @admin = User.create(name: name, email: email, password: password, email_confirmed: true, role: 'admin')
      if @admin.save
        puts "The admin was created successfully"
      else
        puts "Sorry, the admin was not created! due to the following errors!"
        @admin.errors.full_messages.each do |message|
          puts message
        end
      end
    end
  end
end
