# windows_disk_facts

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)

## Description

This module adds  the following facts on Windows:

### `$::disks`

The output of the Powershell `Get-Disk` command, but in a more Puppet-friendly format

### `$::drives`

The output of the Powershell `Get-PSDrive -PSProvider 'FileSystem'` command, but in a more Puppet-friendly format + additional drive type information ('Fixed' = local hard drive, 'Removable' = removable devices like floppy and usb, 'CD-ROM' = optical drives)

### `$::partitions`

The output of the Powershell `Get-Partition` command, but in a more Puppet-friendly format

## Usage

```puppet
# Loop over all of the partitions and find the one that is mounted to C:\
$::partitions.each |$partition| {
  if $partition['drive_letter'] == 'C' {
    # Do something here
  }
}

# Get the free size of C:\
notice($::drives['C']['free_bytes'])
```

## Testing

This module is tested using Litmus. Here ere the steps:

```shell
bundle exec rake 'litmus:provision_list[vagrant]'
bundle exec rake 'litmus:install_agent'
bundle exec rake 'litmus:install_module'
bundle exec rake 'litmus:acceptance:parallel'
bundle exec rake 'litmus:tear_down'
```

## Contributors

  - [nicolasvan](https:///github.com/nicolasvan)
  - [natemccurdy](https:///github.com/natemccurdy)
  - [covidium](https:///github.com/covidium)
