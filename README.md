azure_file cookbook
========================

Description
===========

This cookbook provides a [Lightweight Resource and Provider](https://chef.readthedocs.io/en/latest/lwrps_custom.html)
to download files from Azure blob storage. It's a replacement for the [s3_file](https://supermarket.chef.io/cookbooks/s3_file)
cookbook for Azure.

Requirements
============

* A Microsoft Azure account is required.
* Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support.
  Chef 0.8+ is recommended. [Download and Install the Chef DK](https://docs.chef.io/install_dk.html).

NOTE: [azure-storage-common](https://rubygems.org/gems/azure-storage-common) gem has runtime dependencies
on [azure-core](https://rubygems.org/gems/azure-core) and [nokogiri](https://rubygems.org/gems/nokogiri)
both of which are embedded in the Chef DK Ruby gems.

Quickstart
==========

    mkdir cookbooks
    cd cookbooks
    git clone https://github.com/adobe/azure_file.git
    chef-client --local-mode --override-runlist azure_file

While this cookbook can be used in `chef-solo` mode, to gain the most flexibility,
we recommend using `chef-client` with a Chef Server.

Recipes
=======

default.rb
----------

The default recipe installs the [azure-storage-common](https://rubygems.org/gems/azure-storage-common)
RubyGem, which this cookbook requires in order to work with the Azure API. Make sure that the `azure_file`
recipe is in the node or role `run_list` before any resources from this cookbook are used.

    "run_list": [
      "recipe[azure_file]"
    ]

The `gem_package` is created as a Ruby Object and thus installed during the Compile
Phase of the Chef run.

Resources and Providers
=======================

This cookbook provides one resource and a corresponding provider.

## azure_file

This resource is a wrapper around the core [`remote_file`](https://docs.chef.io/resource_remote_file.html)
resource that will generate an expiring link (SAS token) if you pass `access_key` or MSI access token if you pass `msi_client_id` to retrieve your file from protected blob storage.

Actions:

* `create` - create the file
* `create_if_missing` - create the file if it does not already exist. default
* `delete` - delete the file
* `touch` - touch the file

Attribute Parameters:

* `storage_account` - the azure storage account you are accessing
* `access_key` - the access key to this azure storage account
* `msi_client_id` - the MSI client id with at least read permission to the storage account
* `path` - where this file will be created on the machine
* `remote_path` - the path of the file/key to pull including folder
* `container` - the name of the azure blob storage container/bucket from where to pull

The following parameters are inherited from the [`remote_file`](https://docs.chef.io/resource_remote_file.html)
resource:

* `owner`
* `group`
* `mode`
* `checksum`
* `backup`
* `inherits`
* `rights`

Examples:

### Using Azure Storage Account Access Keys

```ruby
azure_file '/tmp/secret_file.jpg' do
  storage_account 'secretstorage'
  access_key 'eW91cmtleWluYmFzZTY0.....'
  container 'images'
  remote_path 'secret_file.jpg'
end
```

### Using Azure Managed Service Identity (MSI)
```ruby
azure_file '/tmp/secret_file.jpg' do
  storage_account 'secretstorage'
  msi_client_id 'xxxxx-xxxx-xxxxx-xxxx-xxxxx'
  container 'images'
  remote_path 'secret_file.jpg'
end
```

Unit Test
=========
Unit tests are defined under the `./spec` folder.

To execute unit tests, run the following command:

    chef exec rspec

Code Style
==========
To verify the code style of cookbook, just run the command:

    cookstyle

Contributing
==========

Contributions are welcomed! Read the [Contributing Guide](CONTRIBUTING.md) for more information.

Licensing
==========

This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.

Author
==================

Akash Lalwani (<alalwani@adobe.com>)

