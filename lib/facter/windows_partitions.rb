Facter.add('partitions') do
  confine :kernel => 'windows'

  # Windows 2012 R2
  if :kernelversion == '6.4.9600'
    depth = '999'
  # Windows 2016
  elsif :kernelversion == '10.0.14393'
    depth = '100'
  # Default
  else
    depth = '999'
  end
  
  require_relative '../puppet_x/disk_facts/underscore.rb'
  require 'json'
  setcode do
    partitions = JSON.parse(Facter::Core::Execution.exec("powershell.exe -Command \"Get-Partition | Select-Object * -ExcludeProperty CimClass,CimInstanceProperties,CimSystemProperties | ConvertTo-Json -Depth #{depth} -Compress\"")) rescue []
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
