require 'formula'

class Ace < Formula
  homepage 'http://www.cse.wustl.edu/~schmidt/ACE.html'
  url 'http://download.dre.vanderbilt.edu/previous_versions/ACE-6.1.2.tar.bz2'
  sha1 'd2f22607cbb1246abd2f4b77647f37442d117a7e'

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

    # First, we figure out the names of header files and make files
    # for this version of OSX.
    ver = %x[sw_vers -productVersion].chomp.split(".")
    ver = ver.slice(0).to_i*100 + ver.slice(1).to_i
    name = { 1002 => 'macosx',
             1003 => 'macosx_panther',
             1004 => 'macosx_tiger',
             1005 => 'macosx_leopard',
             1006 => 'macosx_snowleopard',
             1007 => 'macosx_lion',
             1008 => 'macosx_mountainlion' }[ver]
    makefile = "platform_#{name}.GNU"
    header = "config-" + name.sub('_','-') + ".h"

    # Now, we give those files the appropriate standard names.
    ln_sf header, "ace/config.h"
    ln_sf makefile, "include/makeinclude/platform_macros.GNU"

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
