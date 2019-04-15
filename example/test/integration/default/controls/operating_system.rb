control 'operating_system' do
# OS should be ubuntu	
  describe command('lsb_release -a') do
    its('stdout') { should match (/Ubuntu/) }
  end

# Nginx package should be installed
  describe package("nginx") do
    it { should be_installed }
  end

# Nginx configuration file should exist
  describe file("/etc/nginx/sites-available/localhost") do
    it { should exist }
  end
end
