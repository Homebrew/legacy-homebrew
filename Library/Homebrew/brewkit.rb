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
require 'hw.model'

ENV['MACOSX_DEPLOYMENT_TARGET']='10.5'
ENV['CFLAGS']='-O3 -w -pipe -fomit-frame-pointer -mmacosx-version-min=10.5'
ENV['LDFLAGS']='' # to be consistent, we ignore the environment usually already

# optimise all the way to eleven, references:
# http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
# http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
# http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
case hw_model
  when :core1
    # Core DUO is a 32 bit chip
    ENV['CFLAGS']="#{ENV['CFLAGS']} -march=prescott -mfpmath=sse -msse3 -mmmx"
  when :core2
    # Core 2 DUO is a 64 bit chip
    # GCC 4.3 will have a -march=core2, but for now nocona is correct
    ENV['CFLAGS']="#{ENV['CFLAGS']} -march=nocona -mfpmath=sse -msse3 -mmmx"
    
    # OK so we're not doing 64 bit yet... but we will with Snow Leopard
    # -mfpmath=sse defaults to on for the x64 compiler
    #ENV['CFLAGS']="#{ENV['CFLAGS']} -march=nocona -msse3 -mmmx -m64"
    #ENV['LDFLAGS']="-arch x86_64"

  when :xeon, :macpro
    # TODO what optimisations for xeon?

  when :ppc   then abort "Sorry, Homebrew does not support PowerPC architectures"
  when :dunno then abort "Sorry, Homebrew cannot determine what kind of Mac this is!"
end

ENV['CXXFLAGS']=ENV['CFLAGS']

# lets use gcc 4.2, it is newer and "better", at least I believe so, mail me
# if I'm wrong
ENV['CC']='gcc-4.2'
ENV['CXX']='g++-4.2'
ENV['MAKEFLAGS']="-j#{OSX::NSProcessInfo.processInfo.processorCount}"


unless HOMEBREW_PREFIX == '/usr/local'
  ENV['CPPFLAGS']="-I#{HOMEBREW_PREFIX}/include"
  ENV['LDFLAGS']="-L#{HOMEBREW_PREFIX}/lib"
end


def inreplace(path, before, after)
  before=Regexp.escape before.to_s
  after=Regexp.escape after.to_s
  before.gsub! "/", "\\\/"
  after.gsub! "/", "\\\/"
  before.gsub! "'", '\''
  after.gsub! "'", '\''

  # TODO this sucks
  # either use 'ed', or allow regexp and use a proper ruby function
  `perl -pi -e $'s/#{before}/#{after}/g' "#{path}"`
end
