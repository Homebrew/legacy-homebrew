# Fixes permissions on the homebrew install directory
# and also Perl, Pyhton and Ruby libraries directories.
# This script is inspired by the homebrew install script
# available at https://gist.github.com/323731

def sudo *args
  args = if args.length > 1
    args.unshift "/usr/bin/sudo"
  else
    "/usr/bin/sudo #{args}"
  end
  #ohai *args
  system *args
end

abort "Don't run this as root!" if Process.uid == 0
abort <<-EOABORT unless `groups`.split.include? "staff"
This script requires the user #{ENV['USER']} to be in the staff group. If this
sucks for you then you can install Homebrew in your home directory or however
you please; please refer to the website. If you still want to use this script
the following command should work:

    dscl /Local/Default -append /Groups/staff GroupMembership $USER
EOABORT

ohai "This script will check permissions for:"
puts "#{HOMEBREW_PREFIX}, /Library/Perl, /Library/Python, /Library/Ruby"

chmods = %w(  . bin etc include lib lib/pkgconfig Library sbin share var
              share/locale share/man share/man/man1 share/man/man2
              share/man/man3 share/man/man4 share/man/man5 share/man/man6
              share/man/man7 share/man/man8 share/info share/doc
              share/aclocal ).map{ |d| "#{HOMEBREW_PREFIX}/#{d}" }.
              push( "/Library/Perl", "/Library/Python", "/Library/Ruby" ).
              select{ |d| File.directory? d and not File.writable? d }
chgrps = chmods.reject{ |d| File.stat(d).grpowned? }

unless chmods.empty?
  ohai "The following directories will be made group writable:"
  puts *chmods
  sudo "/bin/chmod", "g+w", *chmods
end

unless chgrps.empty?
  ohai "The following directories will have their group set to staff:"
  puts *chgrps
  sudo "/usr/bin/chgrp", "staff", *chgrps
end

ohai "Permissions successfully fixed!"