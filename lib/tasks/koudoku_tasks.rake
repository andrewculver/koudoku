namespace :koudoku do
  desc "Install koudoku"
  task :install do
    system 'rails g koudoku:install'
  end

  desc "Install koudoku views for application-specific modification"
  task :views do
    system 'rails g koudoku:views'
  end
end

