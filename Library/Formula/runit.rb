# Author:: Joshua Timberman <joshua@opscode.com>

require 'formula'

class Runit <Formula
  url 'http://smarden.org/runit/runit-2.1.1.tar.gz'
  homepage 'http://smarden.org/runit'
  md5 '8fa53ea8f71d88da9503f62793336bc3'

  def install
    # Runit untars to 'admin/runit-VERSION'
    Dir.chdir("runit-2.1.1")

    # Per the installation doc on OS X, we need to make a couple changes.
    system "echo 'cc -Xlinker -x' >src/conf-ld"
    inreplace 'src/Makefile', / -static/, ''
    system "package/compile"

    # The commands are compiled and copied into the 'command' directory and 
    # names added to package/commands. Read the file for the commands and
    # install them in homebrew.
    rcmds = File.open("package/commands").read
    rcmds.each do |r|
      bin.install("command/#{r.chomp}")
    end
  end
end
