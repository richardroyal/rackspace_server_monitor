# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :check do
    state "MyString"
    server nil
  end
end
