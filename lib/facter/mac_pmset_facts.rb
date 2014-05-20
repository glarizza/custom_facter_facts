#  Fact to read pmset values
#
#  This fact will read the output from `pmset -g custom` which will
#  list all pmset values for the system. It specifically strips out
#  All title lines (i.e. lines that begin with 'Battery' or 'AC'), but
#  that logic is hardcoded and frail, so if this fails on newer versions
#  of OS X, you might want to start there.

IO.popen('/usr/bin/pmset -g custom').readlines.each do |line|
  # Prepare each line into an array of two values
  item_array = line.strip.chomp.split

  # Strip out the title lines here
  # NOTE: This is hardcoded and might need updated with newer versions of OS X
  next if item_array.member?('Battery') or item_array.member?('AC')

  # Create the individual facts based on the array of key/value pairs
  Facter.add("pmset_#{item_array[0]}") do
    setcode do
      item_array[1]
    end
  end
end
