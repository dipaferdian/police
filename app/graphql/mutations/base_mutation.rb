module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    # argument_class Types::BaseArgument
    # field_class Types::BaseField
    # input_object_class Types::BaseInputObject
    # object_class Types::BaseObject
    field :errors, [Types::ErrorType], null: true

    def authenticate_user!
      raise GraphQL::ExecutionError, 'You are not authorized' unless current_user
    end

    def authenticate_admin!
      raise GraphQL::ExecutionError, 'You are not authorized' unless current_admin
    end

    def current_user
      context[:current_user]
    end

    def current_admin
      context[:current_admin]
    end

    def respond_with_errors(resource)
      { errors: construct_error_messages(resource) }
    end

    def respond_single_error(detail, path: nil)
      raise GraphQL::ExecutionError, detail
    end

    private
    def construct_error_messages(resource)
      resource.errors.messages.map do |field, _message|
        {
          path: field.to_s.camelize(:lower),
          detail: resource.errors.full_messages_for(field).join(', ')
        }
      end
    end
  end
end
