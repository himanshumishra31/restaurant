namespace :user do
  task new: :environment do
    User.all.each(&:generate_slug)
  end
end
