class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "http://www.cse.wustl.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.2.tar.bz2"
  sha256 "d8e5ad92eab743936fb8921301e7df09a4d331270be2b7b3dec7f47b8ba2ce5f"

  bottle do
    sha1 "90cb518c4554949453de2eb406a7d1ef8fda3880" => :yosemite
    sha1 "2a58aa9a687ed6b8d3eef8f982b0c96554d85de7" => :mavericks
    sha1 "faa49b7abaf6661f0e4cff46715755985a4a980a" => :mountain_lion
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
