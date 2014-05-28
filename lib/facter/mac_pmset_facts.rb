#  Fact to read pmset values
#
#  This fact will read the output from `pmset -g custom` which will
#  list all pmset values for the system. It specifically strips out
#  All title lines (i.e. lines that begin with 'Battery' or 'AC') and
#  creates facts for both the Battery and AC sections. This is terribly
#  hardcoded due to the split I had to do - so patches are absolutely
#  welcome.

# Read in pmset values and split into two separate arrays
# based on the nasty hardcoded element 16
if Facter.value(:osfamily) == 'Darwin'
  pmset_array = IO.popen('/usr/bin/pmset -g custom').readlines
  battery_array, ac_array = pmset_array.each_slice(16).to_a

  # Remove Headers
  battery_array.shift
  ac_array.shift

  # Battery Facts
  battery_array.each do |element|
    key = element.strip.split
    Facter.add("pmset_battery_#{key[0]}") do
      setcode do
        key[1]
      end
    end
  end

  # AC Facts
  ac_array.each do |element|
    key = element.strip.split
    Facter.add("pmset_ac_#{key[0]}") do
      setcode do
        key[1]
      end
    end
  end
end
