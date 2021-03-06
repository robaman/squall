module Squall
  # OnApp User
  class User < Base
    # Return a list of all users
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user']}
    end


    # Create a new User
    #
    # ==== Options
    #
    # * +options+ - Params for creating the User
    #
    # ==== Example
    #
    #   create :login      => 'bob',
    #          :email      => 'something@example.com',
    #          :password   => 'secret',
    #          :first_name => 'Bob',
    #          :last_name  => 'Smith',
    #          :group_id   => 1
    def create(options = {})
      params.required(:login, :email, :password).accepts(:first_name, :last_name, :user_group_id, :role_ids, :role, :billing_plan_id).validate!(options)
      request(:post, '/users.json', default_params(options))
    end

    # Return a Hash of the given User
    def show(id)
      response = request(:get, "/users/#{id}.json")
      response.first[1]
    end

    # Create a new API Key for a User
    def generate_api_key(id)
      request(:post, "/users/#{id}/make_new_api_key.json")
    end

    # Suspend a User
    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response.first[1]
    end

    # Activate a user
    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response.first[1]
    end
    alias_method :unsuspend, :activate

    # Delete a user
    def delete(id)
      response = request(:delete, "/users/#{id}.json")
      success
    end

    # Get the stats for a User
    def stats(id)
      response = request(:get, "/users/#{id}/vm_stats.json")
      response.first['vm_stats']
    end

    # Return a list of VirtualMachines for a User
    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end

    # Validate availability of email address.
    def validate_email(email)
      response = request(:post, "/users/validate_login.json", :query => {:email => email})
      response["valid"]
    end

    # Edit a role for a user
    #
    # ==== Options
    #
    # * +id+ - id of the User
    # * +roles+ - A single Role id or Array of Roles
    #
    # ==== Example
    #
    #   edit_role 1, 2 # Role 2
    #   edit_role 1, [1,2] # Role 1 & 2
    def edit_role(id, *roles)
      request(:put, "/users/#{id}.json", default_params(:role_ids => roles))
    end
  end
end
