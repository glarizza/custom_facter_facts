#  Filename: lib/facter/ipaddress_segment_matching.rb
#  Factname: 'internal_network'
#  Purpose:  This fact allows you to correlate IP subnets with a segment
#            name. To modify it, simply change the `network_segments` hash
#            and add a segment name and IP subnet/mask.

require 'ipaddr'

Facter.add(:internal_network) do
  setcode do
    # NOTE: To extend this fact, modify this hash and include a segment name
    #       along with an IP subnet and subnet mask
    network_segments = {
      'DEV'        => IPAddr.new('10.13.0.0/22'),
      'TEST'       => IPAddr.new('10.14.0.0/22'),
      'SERVICES'   => IPAddr.new('10.15.0.0/22')
    }

    #######################
    # Do not modify below #
    #######################

    segment_name = nil

    # Iterate through all segments and find the one that matches
    network_segments.each do |segment, address|
      if address.include?(Facter.value(:ipaddress))
        segment_name = segment
      end
    end

    # Return the name of the segment that matches
    segment_name
  end
end

