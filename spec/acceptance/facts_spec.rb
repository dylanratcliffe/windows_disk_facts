require 'spec_helper_acceptance'

describe 'Checking facts' do
  before(:all) do
    # Create directory for facts
    run_shell('New-Item C:/facts_output -Type directory -Force')
    run_shell('Remove-Item C:/facts_output/* -Force -Recurse')
  end

  it 'should be able to gather facts using "puppet facts"' do
    result = run_shell('puppet facts > C:/facts_output/facts.json')

    expect(result.exit_code).to be(0)
    expect(result.stderr).to be_empty  
  end

  describe 'Gathered facts' do
    before(:all) do
      @facts = JSON.parse(file('C:/facts_output/facts.json').content)
    end

    it 'should actually cvontain the facts we expect' do
      expect(@facts).to have_key("disks")
      expect(@facts).to have_key("drives")
      expect(@facts).to have_key("partitions")
    end

    describe 'disks fact' do
      it 'should be the correct formet' do
        expect(@facts['disks']).to be_a(Hash)
        expect(@facts['disks']).to have_key("0")
      end
    end

    describe 'drives fact' do
      it 'should be the correct formet' do
        expect(@facts['drives']).to be_a(Hash)
        expect(@facts['drives']).to have_key("C")

      end
    end

    describe 'partitions fact' do
      it 'should be the correct formet' do
        expect(@facts['partitions']).to be_a(Array)
        expect(@facts['partitions'].length).to be > 1
      end
    end
  end
end