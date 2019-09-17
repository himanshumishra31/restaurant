namespace :update_slug do
  task new: :environment do
    User.all.each(&:generate_slug)
  end
end
