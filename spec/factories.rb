FactoryGirl.define do
  factory :account do
    account_type "Test Type"
    token "test_token_pivotal"

    factory :pivotal do
      account_type "pivotal"
      token "pivotal_token"
    end
  end
end