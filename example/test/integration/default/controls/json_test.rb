# adding variable which value is the attribute "public_dns", specified in .kitchen.yml
# public_dns is actually our output from terraform
# We need to perform the test in this way, because every single time we create an AWS instance, will be with different Public DNS name.

dns = attribute("public_dns", {})

# adding test called "ckeck_json"
# it will ckeck whether the JSON is accessible.

control 'check_json' do
  describe http("http://#{dns}/vagrant/xenial64/") do
    its('status') { should cmp 200 }
  end
end
