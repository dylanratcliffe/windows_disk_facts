Facter.add('partitions') do
  confine :kernel => 'windows'

  require_relative '../puppet_x/disk_facts/underscore.rb'
  require 'json'
  setcode do
    kernelmajversion = Facter.value('kernelmajversion')
    next if kernelmajversion == '6.0' # Get-Partition is not available on Windows Server 2008
    next if kernelmajversion == '6.1' # Get-Partition is not available on Windows Server 2008 R2

    partitions = JSON.parse(Facter::Core::Execution.exec("powershell.exe -Command \"Get-Partition | Select-Object * -ExcludeProperty CimClass,CimInstanceProperties,CimSystemProperties | ConvertTo-Json -Depth 100 -Compress\""))
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
