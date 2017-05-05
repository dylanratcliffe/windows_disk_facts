Facter.add('disks') do
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
    disks_hashes = JSON.parse(Facter::Core::Execution.exec("powershell.exe -Command \"Get-Disk | select *  -ExcludeProperty CimClass,CimInstanceProperties,CimSystemProperties | ConvertTo-Json -Depth #{depth} -Compress\"")) rescue []
    disks_hashes_renamed = []
    out = {}

    # Make sure that we can handle only one disk
    disks_hashes = [disks_hashes] if disks_hashes.kind_of?(Hash)
    
    # Change camel case to unserscores
    disks_hashes.each do |disk|
      current_disk_renamed = {}
      disk.each do |key,value|
        current_disk_renamed[key.underscore] = value
      end
      disks_hashes_renamed << current_disk_renamed
    end

    # Make the disk number the key
    disks_hashes_renamed.each do |disk|
      out[disk['number']] = disk
    end

    out
  end
end
