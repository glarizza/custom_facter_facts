require 'puppet'

Facter.add(:mac_local_users) do
  confine :osfamily => :darwin
  setcode do
    array_of_users = Puppet::Type.type(:user).provider(:directoryservice).instances.collect(&:name)
    Facter.version > '2' ? array_of_users : array_of_users.join(',')
  end
end
