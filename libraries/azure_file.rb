#
# Cookbook:: azure_file
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

def source_path(storage_account, container, remote_path)
  # This is done to follow the similar pattern to s3_file cookbook of bucket and remote_path as key to pull.
  source_path = "https://#{storage_account}.blob.core.windows.net/#{container}/#{remote_path}"
end

def azure_signed_uri(storage_account, access_key, container, remote_path)
  require 'azure/storage/common'

  # Creating an instance of `Azure::Storage::Common::Core::Auth::SharedAccessSignature`
  sas = Azure::Storage::Common::Core::Auth::SharedAccessSignature.new(storage_account, access_key)

  complete_remote_path = source_path(storage_account, container, remote_path)
  parsed_remote_path = URI.parse(complete_remote_path)

  # Generate signed URI to download the file.
  signed = sas.signed_uri(parsed_remote_path, false, {})
  signed_remote_path = signed.to_s
end
