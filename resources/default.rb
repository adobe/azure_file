#
# Cookbook:: azure_file
# Resources:: default
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

actions :create, :create_if_missing, :touch, :delete

default_action :create_if_missing

attribute :path, :kind_of => String, :name_attribute => true
attribute :container, :kind_of => String, :required => true
attribute :remote_path, :kind_of => String, :required => true
attribute :storage_account, :required => true
attribute :access_key, :default => nil
attribute :msi_client_id, :default => nil
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :mode, :kind_of => [String, NilClass], :default => nil
attribute :checksum, :kind_of => [String, NilClass], :default => nil
attribute :backup, :kind_of => [Integer, FalseClass], :default => 5
if node['platform_family'] == 'windows'
  attribute :inherits, :kind_of => [TrueClass, FalseClass], :default => true
  attribute :rights, :kind_of => Hash, :default => nil
end
