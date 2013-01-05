desc "Install koudoku"
namespace :koudoku do
  task :install do
    system 'rails g koudoku:install'
  end
end
