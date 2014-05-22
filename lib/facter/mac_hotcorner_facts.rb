#  Hot Corner Facts for Mac

#  This custom fact file will scrape the dock plist looking for hot corner settings and
#  will return fact values for each corner indicating which action the corner
#  triggers. There's also a block to set a fact called
#  'disable_screen_saver_corners' that can be used to determine which corners
#  have been set to disable the screen saver...which can be a potential
#  security vulnerability. In that event, you could write a defined resource
#  type to change the value to a more desirable one.
#
#  This file relies on a 'current_user' custom fact which is also in this
#  repository. These facts are confined to OS X.

if Facter.value(:osfamily) == 'Darwin'
  corner_map = {
    'tl' => 'top_left',
    'tr' => 'top_right',
    'bl' => 'bottom_left',
    'br' => 'bottom_right'
  }
  action_map = {
    '1'  => 'none',
    '2'  => 'mission_control',
    '3'  => 'application_windows',
    '4'  => 'desktop',
    '5'  => 'start_screen_saver',
    '6'  => 'disable_screen_saver',
    '7'  => 'dashboard',
    '10' => 'put_display_to_sleep',
    '11' => 'launchpad',
    '12' => 'notification_center',
  }
  current_user = Facter.value(:current_user)
  disable_sleep_array = []

  Facter::Util::Resolution.exec("defaults read /Users/#{current_user}/Library/Preferences/com.apple.dock.plist").scan(/wvous-(..)-corner\" = (\d)/).each do |corner|
    corner_name  = corner[0]
    corner_value = corner[1]

    Facter.add("hotcorner_#{corner_map[corner_name]}") do
      setcode do
        action_map[corner_value]
      end
    end

    if corner_value == '6'
      disable_sleep_array << corner_name
    end
  end

  Facter.add(:disable_screen_saver_corners) do
    setcode do
      disable_sleep_array.join(',')
    end
  end
end

