module Mutations
  class Register < BaseMutation
    argument :account_type, Types::AccountTypeType, required: true
    argument :name, String, required: true
    argument :company_number, String, required: false
    argument :date_of_birth, String, required: false
    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(**kwargs)
      account = Account.new(kwargs)
      if account.save
        account.token = account.to_sgid(expires_in: 12.hours, for: 'graphql')
        account
      else
        raise GraphQL::ExecutionError.new("Register failed.")
      end
    end
  end
end