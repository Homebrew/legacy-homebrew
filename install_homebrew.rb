#!/usr/bin/ruby
#
# I deliberately didn't DRY /usr/local references into a variable as this
# script will not "just work" if you change the destination directory. However
# please feel free to fork it and make that possible.
#
# If you do fork, please ensure you add a comment here that explains what the
# changes are intended to do and how well you tested them.
#

module Tty extend self
  def blue; bold 34; end
  def white; bold 39; end
  def red; underline 31; end
  def reset; escape 0; end
  def underline; underline 39; end
  def bold n; escape "1;#{n}" end
  def underline n; escape "4;#{n}" end
  def escape n; "\033[#{n}m" if STDOUT.tty? end
end

def ohai s
  puts "#{Tty.blue}==>#{Tty.white} #{s}#{Tty.reset}"
end

def sudo *params
  if params.length == 1
    cmd = "sudo #{params.first}"
    ohai cmd
    system cmd
  else
    ohai "sudo" + params.map{ |p| p.gsub ' ', '\\ ' } * ' '
    system "sudo", *params
  end
end

def opoo warning
  puts "#{Tty.red}Warning#{Tty.reset}: #{warning}"
end

def getc  # NOTE only tested on OS X
  system "stty raw -echo"
  STDIN.getc
ensure
  system "stty -raw echo"
end

####################################################################### script
abort "/usr/local/.git already exists!" if File.directory? "/usr/local/.git"

ohai "This script will install:"
puts "/usr/local/bin/brew"
puts "/usr/local/Library/Formula/..."
puts "/usr/local/Library/Homebrew/..."

chmods = %w(bin etc include lib sbin share var . share/locale share/man share/info share/doc share/aclocal).
            map{ |d| "/usr/local/#{d}" }.
            select{ |d| File.directory? d and not File.writable? d }

unless chmods.empty?
  ohai "The following directories will be made group writable:"
  puts *chmods
end

puts
puts "Press enter to continue"
abort unless getc == 13

if File.directory? "/usr/local"
  sudo "/bin/chmod", "g+w", *chmods unless chmods.empty?
else
  sudo "/bin/mkdir /usr/local"
  sudo "/bin/chmod g+w /usr/local"
end

Dir.chdir "/usr/local" do
  tarball = "http://github.com/mxcl/homebrew/tarball/master"
  ohai "Extracting: #{tarball}"
  # -m to stop tar erroring out if it can't modify the mtime for root owned directories
  system "/usr/bin/curl -#L #{tarball} | /usr/bin/tar xz -m --strip 1"
end

ohai "Installation successful!"

if ENV['PATH'].split(':').include? '/usr/local/bin'
  puts "Yay! Now learn to brew:"
  puts
  puts "    brew help"
  puts
else
  opoo "/usr/local/bin is not in your PATH"
end
