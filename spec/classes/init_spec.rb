require 'spec_helper'
describe 'disk_facts' do

  context 'with defaults for all parameters' do
    it { should contain_class('disk_facts') }
  end
end
