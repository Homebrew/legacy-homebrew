class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "http://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.3.tar.bz2"
  sha256 "f362e45f624db3343db529654b601d5df69b5f56fa4597cf453da35d80989888"

  bottle do
    cellar :any
    sha256 "170a94d38f40f743b111270b73490d4f048c6665f78fd8c6d5cf09690ea45808" => :yosemite
    sha256 "11a3de79f7bced79f78aaa3449dd2de513499f81d333ac96421601b02e23d90c" => :mavericks
    sha256 "6d9e043cef8e05e73e144f41a50f616599cc26fb91d5da016f525e989d32eed8" => :mountain_lion
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
