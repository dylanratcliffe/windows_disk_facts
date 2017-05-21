Facter.add('partitions') do
  confine :kernel => 'windows'

  require_relative '../puppet_x/disk_facts/underscore.rb'
  require 'json'
  setcode do
    kernelmajversion = Facter.value('kernelmajversion')
    next if kernelmajversion == '6.0' # Get-Partition is not available on Windows Server 2008
    next if kernelmajversion == '6.1' # Get-Partition is not available on Windows Server 2008 R2

    if kernelmajversion.split('.')[0].to_i >= 10 # If it's 2016 or newer we can no longer use depth > 100
      depth = '100'
    else
      depth = '999'
    end

    partitions = JSON.parse(Facter::Core::Execution.exec("powershell.exe -Command \"Get-Partition | Select-Object * -ExcludeProperty CimClass,CimInstanceProperties,CimSystemProperties | ConvertTo-Json -Depth #{depth} -Compress\""))
    partitions_renamed = []

    # Make sure that we can handle only one partition
    partitions = [partitions] if partitions.kind_of?(Hash)

    # Change camel case to unserscores
    partitions.each do |partition|
      current_partition_renamed = {}
      partition.each do |key,value|
        current_partition_renamed[key.underscore] = value
      end
      partitions_renamed << current_partition_renamed
    end
    partitions_renamed
  end
end
