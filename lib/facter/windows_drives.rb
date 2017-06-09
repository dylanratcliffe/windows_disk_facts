Facter.add('drives') do
  confine :kernel => 'windows'

  require_relative '../puppet_x/disk_facts/underscore.rb'
  require 'json'
  setcode do

    drives = JSON.parse(Facter::Core::Execution.exec("powershell.exe -Command \"Get-PSDrive -PSProvider 'FileSystem' | Select-Object * -ExcludeProperty Provider,Credential,CurrentLocation | ConvertTo-Json -Depth 100 -Compress\"")) rescue []
    drives_renamed = []
    out = {}

    # Make sure that we can handle only one drive
    drives = [drives] if drives.kind_of?(Hash)

    # Change camel case to unserscores
    drives.each do |drive|
      current_drive_renamed = {}
      drive.each do |key,value|
        current_drive_renamed[key.underscore] = value
      end
      drives_renamed << current_drive_renamed
    end

    # Set the key to the drive letter for each drive
    drives_renamed.each do |drive|
      out[drive['name']] = drive
    end

    # Rename sizes to reflect that they are in bytes
    # TODO: Add size in human readable format
    out.each do |letter,details|
      details.keys.each { |k| details["#{k}_bytes"] = details.delete(k) if details[k].is_a? Integer }
    end
    out
  end
end
