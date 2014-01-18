require 'formula'

class Ace < Formula
  homepage 'http://www.cse.wustl.edu/~schmidt/ACE.html'
  url 'http://download.dre.vanderbilt.edu/previous_versions/ACE-6.2.4.tar.bz2'
  sha1 '8dba7ced5d337c1073c0fc28d53e3869a9bd0048'

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete '_'
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV['ACE_ROOT'] = buildpath
    ENV['DYLD_LIBRARY_PATH'] = "#{buildpath}/ace:#{buildpath}/lib"

    # Done! We go ahead and build.
    cd "ace" do
      system "make", "-f", "GNUmakefile.ACE",
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
end
