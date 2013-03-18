# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "MyString"
    free_trial_length "MyString"
  end
end
