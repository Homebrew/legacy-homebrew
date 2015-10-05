class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "http://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.3.tar.bz2"
  sha256 "f362e45f624db3343db529654b601d5df69b5f56fa4597cf453da35d80989888"

  bottle do
    cellar :any
    sha256 "4cab5cd3539a5c1d9c622a01b4739374c6a84a1b14312fbba1043a0aeb69d012" => :el_capitan
    sha256 "e8a145050c666048031f8ebd2404eaccf2b6bd52fbd6eba75ee98ba780480e90" => :yosemite
    sha256 "4e2fdfc92d15c28413102c1fbabe9f9953f0b0892c951123bc50b7ce166d4a68" => :mavericks
  end

  def install
    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/ace:#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"
  end
end
