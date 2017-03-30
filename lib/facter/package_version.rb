###################
# package_version #
###################  
#  
# This fact will use the Puppet RAL to query whether a package has been
# installed (using the default package provider). If it is, the version string
# that Puppet is aware of will be reported. If not, this fact will be absent.
# 
# To specify the name of the package you're looking for, just change the
# "package" variable below from 'bash' to the package name as known by the
# default package provider.
#
# Right now the actual fact name is 'bash_version' because the example uses the
# 'bash' package. To change the fact name you'll need to change
# :bash_version to whatever your fact name should be (starting with a colon
# ':' - so if you wanted to call the fact 'yum_version' you would change it to
# say :yum_version)
#
# Thanks to https://github.com/whatsaranjit and https://github.com/natemccurdy
# for their help!
#
require 'puppet/type/package'

Facter.add(:bash_version) do
  setcode do
    package  = 'bash'
    instance = Puppet::Type.type('package').instances.select { |pkg| pkg.name == package }.first
    if instance
      ensure_property = instance.property(:ensure)
      instance.retrieve[ensure_property]
    end
  end
end
