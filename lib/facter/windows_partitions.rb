Facter.add('partitions') do
  confine :kernel => 'windows'

  require_relative '../puppet_x/disk_facts/underscore.rb'
  require 'json'
  setcode do

  # set windows 2008 to true/False
  win2008 = Facter.value(:kernelmajversion) == '6.1' || Facter.value(:kernelmajversion) == '6.0'
  result = if win2008 == true
             partitions = JSON.parse(Facter::Core::Execution.exec("powershell.exe -noprofile -Command \"Get-PSDrive -PSProvider 'FileSystem' | Select-Object * -ExcludeProperty Provider,Credential,CurrentLocation | ConvertTo-Json -Depth 100 -Compress\""))
           else
             partitions = JSON.parse(Facter::Core::Execution.exec("powershell.exe -noprofile -Command \"Get-Partition | Select-Object * -ExcludeProperty CimClass,CimInstanceProperties,CimSystemProperties | ConvertTo-Json -Depth 100 -Compress\""))
           end
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
