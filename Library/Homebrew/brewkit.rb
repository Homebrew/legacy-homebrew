#  Copyright 2009 Max Howell <max@methylblue.com>
#
#  This file is part of Homebrew.
#
#  Homebrew is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Homebrew is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Homebrew.  If not, see <http://www.gnu.org/licenses/>.

require 'osx/cocoa' # to get number of cores
require 'formula'

# optimise all the way to eleven, references:
# http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
# http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
# http://gcc.gnu.org/onlinedocs/gcc-4.0.1/gcc/i386-and-x86_002d64-Options.html
ENV['MACOSX_DEPLOYMENT_TARGET']='10.5'
ENV['CFLAGS']=ENV['CXXFLAGS']='-O3 -w -pipe -fomit-frame-pointer -march=prescott'

# lets use gcc 4.2, it is newer and "better", at least I believe so, mail me
# if I'm wrong
ENV['CC']='gcc-4.2'
ENV['CXX']='g++-4.2'
ENV['MAKEFLAGS']="-j#{OSX::NSProcessInfo.processInfo.processorCount}"

unless $root.to_s == '/usr/local'
  ENV['CPPFLAGS']='-I'+$root+'include'
  ENV['LDFLAGS']='-L'+$root+'lib'
end


######################################################################## utils

def inreplace(path, before, after)
  before=before.to_s.gsub('"', '\"').gsub('/', '\/')
  after=after.to_s.gsub('"', '\"').gsub('/', '\/')

  # we're not using Ruby because the perl script is more concise
  #TODO the above escapes are worse, use a proper ruby script :P
  #TODO optimise it by taking before and after as arrays
  #Bah, just make the script writers do it themselves with a standard collect block
  #TODO use ed -- less to escape
  #TODO the above doesn't escape all regexp symbols!
  `perl -pi -e "s/#{before}/#{after}/g" "#{path}"`
end
