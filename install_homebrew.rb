#!/usr/bin/ruby
# This script installs to /usr/local only. To install elsewhere you can just
# untar https://github.com/mxcl/homebrew/tarball/master anywhere you like.

module Tty extend self
  def blue; bold 34; end
  def white; bold 39; end
  def red; underline 31; end
  def reset; escape 0; end
  def bold n; escape "1;#{n}" end
  def underline n; escape "4;#{n}" end
  def escape n; "\033[#{n}m" if STDOUT.tty? end
end

class Array
  def shell_s
    cp = dup
    first = cp.shift
    cp.map{ |arg| arg.gsub " ", "\\ " }.unshift(first) * " "
  end
end

def ohai *args
  puts "#{Tty.blue}==>#{Tty.white} #{args.shell_s}#{Tty.reset}"
end

def warn warning
  puts "#{Tty.red}Warning#{Tty.reset}: #{warning.chomp}"
end
 
def system *args
  abort "Failed during: #{args.shell_s}" unless Kernel.system *args
end

def sudo *args
  args = if args.length > 1
    args.unshift "/usr/bin/sudo"
  else
    "/usr/bin/sudo #{args.first}"
  end
  ohai *args
  system *args
end

def getc  # NOTE only tested on OS X
  system "/bin/stty raw -echo"
  if RUBY_VERSION >= '1.8.7'
    STDIN.getbyte
  else
    STDIN.getc
  end
ensure
  system "/bin/stty -raw echo"
end

def badlibs
  @badlibs ||= begin
    Dir['/usr/local/lib/*.dylib'].select do |dylib|
      ENV['dylib'] = dylib
      File.file? dylib and not File.symlink? dylib and `/usr/bin/file "$dylib"` =~ /shared library/
    end
  end
end

def macos_version
  @macos_version ||= /(10\.\d+)(\.\d+)?/.match(`/usr/bin/sw_vers -productVersion`).captures.first.to_f
end

####################################################################### script
abort "MacOS too old, see: https://gist.github.com/1144389" if macos_version < 10.5
abort "/usr/local/.git already exists!" unless Dir["/usr/local/.git/*"].empty?
abort "Don't run this as root!" if Process.uid == 0
abort <<-EOABORT unless `groups`.split.include? "staff"
This script requires the user #{ENV['USER']} to be in the staff group. If this
sucks for you then you can install Homebrew in your home directory or however
you please; please refer to the website. If you still want to use this script
the following command should work:

    dscl /Local/Default -append /Groups/staff GroupMembership $USER
EOABORT

ohai "This script will install:"
puts "/usr/local/bin/brew"
puts "/usr/local/Library/Formula/..."
puts "/usr/local/Library/Homebrew/..."

chmods = %w( . bin etc include lib lib/pkgconfig Library sbin share var var/log share/locale share/man
             share/man/man1 share/man/man2 share/man/man3 share/man/man4
             share/man/man5 share/man/man6 share/man/man7 share/man/man8
             share/info share/doc share/aclocal ).
            map{ |d| "/usr/local/#{d}" }.
            select{ |d| File.directory? d and not File.writable? d }
chgrps = chmods.reject{ |d| File.stat(d).grpowned? }

unless chmods.empty?
  ohai "The following directories will be made group writable:"
  puts *chmods
end
unless chgrps.empty?
  ohai "The following directories will have their group set to #{Tty.underline 39}staff#{Tty.reset}:"
  puts *chgrps
end

if STDIN.tty?
  puts
  puts "Press enter to continue"
  abort unless getc == 13
end

if File.directory? "/usr/local"
  sudo "/bin/chmod", "g+w", *chmods unless chmods.empty?
  # all admin users are in staff
  sudo "/usr/bin/chgrp", "staff", *chgrps unless chgrps.empty?
else
  sudo "/bin/mkdir /usr/local"
  sudo "/bin/chmod g+w /usr/local"
  # the group is set to wheel by default for some reason
  sudo "/usr/bin/chgrp staff /usr/local"
end

Dir.chdir "/usr/local" do
  ohai "Downloading and Installing Homebrew..."
  # -m to stop tar erroring out if it can't modify the mtime for root owned directories
  # pipefail to cause the exit status from curl to propogate if it fails
  # we use -k because OS X curl has a bunch of bad SSL certificates
  # you may want to remove the -k flag from your fork!
  system "/bin/bash -o pipefail -c '/usr/bin/curl -skSfL https://github.com/mxcl/homebrew/tarball/master | /usr/bin/tar xz -m --strip 1'"
end

warn "/usr/local/bin is not in your PATH." unless ENV['PATH'].split(':').include? '/usr/local/bin'
warn "Now install Xcode: http://developer.apple.com/technologies/xcode.html" unless Kernel.system "/usr/bin/which -s gcc"

unless badlibs.empty?
  warn "The following *evil* dylibs exist in /usr/local/lib"
  puts "They may break builds or worse. You should consider deleting them:"
  puts *badlibs
end

ohai "Installation successful!"
puts "Now type: brew help"
