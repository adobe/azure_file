#
# Cookbook:: azure_file
# Providers:: default
#
# Copyright 2018 Adobe. All rights reserved.
# This file is licensed to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. You may obtain a copy
# of the License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.
#

use_inline_resources if defined?(use_inline_resources)

def why_run_supported?
  true
end

action :create do
  do_protected_file(:create)
end

action :create_if_missing do
  do_protected_file(:create_if_missing)
end

action :delete do
  do_protected_file(:delete)
end

action :touch do
  do_protected_file(:touch)
end

def do_protected_file(resource_action)
  if new_resource.access_key.nil? and new_resource.msi_client_id.nil?
    raise 'An error has occurred: Both MSI Client ID and Access Key of storage account are missing.'
  elsif new_resource.msi_client_id.nil?
    remote_path = azure_signed_uri(new_resource.storage_account, new_resource.access_key,
                                     new_resource.container, new_resource.remote_path)
  else
    msi_access_token = msi_get_access_token(new_resource.msi_client_id)
    headers = {"x-ms-version" => "2017-11-09", "Authorization" => "Bearer #{msi_access_token}"}
    remote_path = source_path(new_resource.storage_account, new_resource.container, new_resource.remote_path)
  end

  remote_file new_resource.name do
    path new_resource.path
    source remote_path
    unless new_resource.msi_client_id.nil?
      headers headers
    end
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    checksum new_resource.checksum
    backup new_resource.backup
    if node['platform_family'] == 'windows'
      inherits new_resource.inherits
      rights new_resource.rights
    end
    action resource_action
  end
end
