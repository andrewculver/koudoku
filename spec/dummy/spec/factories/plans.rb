# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "MyString"
    stripe_id "MyString"
    price 1.5
    features "MyText"
    highlight false
    display_order 1
  end
end
