namespace :koudoku do

  desc "Install koudoku"
  task :install do
    system 'rails g koudoku:install'
  end

end
