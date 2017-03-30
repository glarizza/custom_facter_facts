###########################
# package_version_boolean #
###########################
#  
# This fact will use the Puppet RAL to query whether a package has been
# installed (using the default package provider). The fact will return
# a boolean true/false based on the presence of that package.
# 
# To specify the name of the package you're looking for, just change the
# "package" variable below from 'bash' to the package name as known by the
# default package provider.
#
# Right now the actual fact name is 'bash_version_boolean' because the example uses the
# 'bash' package. To change the fact name you'll need to change
# :bash_version_boolean to whatever your fact name should be (starting with a colon
# ':' - so if you wanted to call the fact 'yum_version_boolean' you would change it to
# say :yum_version_boolean)
#
require 'puppet/type/package'

Facter.add(:bash_version_boolean) do
  setcode do
    package = 'bash'
    results = Puppet::Type::Package.instances.select { |p| p.name == package }
    results.length > 0
  end
end

