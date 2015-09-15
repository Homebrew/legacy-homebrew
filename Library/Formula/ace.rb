class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "http://www.cse.wustl.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.2.tar.bz2"
  sha256 "d8e5ad92eab743936fb8921301e7df09a4d331270be2b7b3dec7f47b8ba2ce5f"

  bottle do
    cellar :any
    sha256 "170a94d38f40f743b111270b73490d4f048c6665f78fd8c6d5cf09690ea45808" => :yosemite
    sha256 "11a3de79f7bced79f78aaa3449dd2de513499f81d333ac96421601b02e23d90c" => :mavericks
    sha256 "6d9e043cef8e05e73e144f41a50f616599cc26fb91d5da016f525e989d32eed8" => :mountain_lion
  end

  # Add config/platform support for El Capitan
  # https://github.com/DOCGroup/ATCD/pull/141
  patch :p2 do
    url "https://github.com/DOCGroup/ATCD/pull/141.diff"
    sha256 "4a9584c2eb876245ee1f8442886663a83937380ed5d2ceb70e3594b702f544bb"
  end

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

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
