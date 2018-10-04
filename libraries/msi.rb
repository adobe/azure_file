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

def msi_get_access_token(msi_client_id)
  uri = URI.parse("http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F&client_id=#{msi_client_id}")
  request = Net::HTTP::Get.new(uri)
  request["Metadata"] = "true"
  response = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(request)
  }
    
  msi_response = JSON.parse(response.body)
  if msi_response["error"]
    raise "An error has occurred while fetching the MSI access token for client id: #{msi_client_id}, Error: #{msi_response}"
  end
  msi_response["access_token"]
end
