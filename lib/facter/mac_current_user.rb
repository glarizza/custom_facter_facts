require 'etc'

Facter.add('current_user') do
  confine :osfamily => :darwin
  setcode do
    Etc.getpwuid(File.stat('/dev/console').uid).name
  end
end
