require 'spec_helper_acceptance'

describe 'Checking facts', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  it 'TODO' do
    # host_inventory['facter']['os']['name'] # => Fedora
  end

end