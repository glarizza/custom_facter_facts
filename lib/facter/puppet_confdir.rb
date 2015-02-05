# This facter fact returns the value of the Puppet confdir setting for the node
# running puppet or puppet agent.  The intent is to enable Puppet modules to
# automatically have insight into the Puppet configuration directory regardless
# of which version of Puppet (FOSS or PE) is being excuted
#
# The value should be directly usable in a File resource path attribute.


begin
  require 'facter/util/puppet_settings'
rescue LoadError => e
  # puppet apply does not add module lib directories to the $LOAD_PATH (See
  # #4248). It should (in the future) but for the time being we need to be
  # defensive which is what this rescue block is doing.
  rb_file = File.join(File.dirname(__FILE__), 'util', 'puppet_settings.rb')
  load rb_file if File.exists?(rb_file) or raise e
end

Facter.add(:puppet_confdir) do
  setcode do
    # This will be nil if Puppet is not available.
    Facter::Util::PuppetSettings.with_puppet do
      Puppet[:confdir]
    end
  end
end
