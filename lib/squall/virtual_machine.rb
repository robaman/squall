module Squall
  # OnApp VirtualMachine
  class VirtualMachine < Base
    # Return a list of VirtualMachines
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end

    # Return a Hash for the given VirtualMachine
    def show(id)
      response = request(:get, "/virtual_machines/#{id}.json")
      response.first[1]
    end

    # Create a new VirtualMachine
    #
    # ==== Options
    #
    # * +options+ - Params for creating the VirtualMachine
    #
    # ==== Example
    #
    #  params = {
    #    :label => 'testmachine', 
    #    :hypervisor_id => 5,
    #    :hostname => 'testmachine', 
    #    :memory => 512, 
    #    :cpus => 1,
    #    :cpu_shares => 10, 
    #    :primary_disk_size => 10
    #  }
    #
    #  create params
    def create(options = {})
      required = [:label, :hostname, :memory, :cpus, :cpu_shares, :primary_disk_size]
      optional = [:hypervisor_id,
                  :cpu_shares,
                  :swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :template_id,
                  :initial_root_password
      ]
      params.required(required).accepts(optional).validate! options
      response = request(:post, '/virtual_machines.json', default_params(options))
      response['virtual_machine']
    end

    # Build a VirtualMachine
    #
    # ==== Options
    #
    # * +id+
    # * +options+ - :template_id, :required_startup
    def build(id, options = {})
      params.accepts(:template_id, :required_startup).validate! options
      response = request(:post, "/virtual_machines/#{id}/build.json", default_params(options))
      response.first[1]
    end

    # Edit a new VirtualMachine
    #
    # ==== Options
    #
    # * +options+ - Params for editing the VirtualMachine
    #
    # ==== Example
    #
    #  params = {
    #    :label => 'testmachine', 
    #    :hypervisor_id => 5,
    #    :hostname => 'testmachine', 
    #    :memory => 512, 
    #    :cpus => 1,
    #    :cpu_shares => 10, 
    #    :primary_disk_size => 10
    #  }
    #
    #  edit params
    def edit(id, options = {})
      optional = [:label,
                  :hypervisor_id,
                  :hostname,
                  :memory,
                  :cpus,
                  :cpu_shares,
                  :primary_disk_size,
                  :cpu_shares,
                  :swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :template_id,
                  :initial_root_password
      ]
      params.accepts(optional).validate! options
      request(:put, "/virtual_machines/#{id}.json", default_params(options))
    end

    # Change the owner of a VirtualMachine
    #
    # ==== Options
    # * +id+ - id of the VirtualMachine
    # * +user_id+ - id of the target User
    def change_owner(id, user_id)
      response = request(:post, "/virtual_machines/#{id}/change_owner.json", :query => { :user_id => user_id })
      response['virtual_machine']
    end

    # Change the password
    def change_password(id, password)
      response = request(:post, "/virtual_machines/#{id}/reset_password.json", :query => { :new_password => password })
      response['virtual_machine']
    end

    # Migrate a VirtualMachine to a new Hypervisor
    #
    # ==== Options
    #
    # * +id+
    # * +options+ - :destination, :cold_migrate_on_rollback
    def migrate(id, options = {})
      params.required(:destination).accepts(:cold_migrate_on_rollback).validate! options 
      response = request(:post, "/virtual_machines/#{id}/migrate.json", :query => options )
    end

    # Delete a VirtualMachine
    def delete(id)
      request(:delete, "/virtual_machines/#{id}.json")
    end

    # Resize a VirtualMachine's memory
    def resize(id, options = {})
      params.required(:memory).accepts(:allow_migration).validate! options
      response = request(:post, "/virtual_machines/#{id}/resize.json", default_params(options))
      response['virtual_machine']
    end

    # Suspend/Unsuspend a VirtualMachine
    def suspend(id)
      response = request(:post, "/virtual_machines/#{id}/suspend.json")
      response['virtual_machine']
    end
    alias_method :unsuspend, :suspend

    # Unlock a VirtualMachine
    def unlock(id)
      response = request(:post, "/virtual_machines/#{id}/unlock.json")
      response['virtual_machine']
    end

    # Boot a VirtualMachine
    def startup(id)
      response = request(:post, "/virtual_machines/#{id}/startup.json")
      response['virtual_machine']
    end

    # Shutdown a VirtualMachine
    def shutdown(id)
      response = request(:post, "/virtual_machines/#{id}/shutdown.json")
      response['virtual_machine']
    end

    # Stop a VirtualMachine
    def stop(id)
      response = request(:post, "/virtual_machines/#{id}/stop.json")
      response['virtual_machine']
    end

    # Reboot a VirtualMachine
    def reboot(id)
      response = request(:post, "/virtual_machines/#{id}/reboot.json")
      response['virtual_machine']
    end
  end
end
