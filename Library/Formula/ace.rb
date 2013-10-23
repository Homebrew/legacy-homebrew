require 'formula'

class Ace < Formula
  homepage 'http://www.cse.wustl.edu/~schmidt/ACE.html'
  url 'http://download.dre.vanderbilt.edu/previous_versions/ACE-6.2.2.tar.bz2'
  sha1 'b95c55a2a72f3a66b16e9296c77807f4e62e8f93'

  def osx_name
    case MacOS.cat
    when :tiger then 'macosx_tiger'
    when :leopard then 'macosx_leopard'
    when :snow_leopard then 'macosx_snowleopard'
    when :lion then 'macosx_lion'
    # Fix for 6.2.2.
    # There's no Mountain Lion or Mavericks files yet.
    # Reported to d.schmidt@vanderbilt.edu
    else 'macosx_lion'
    end
  end

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

    # First, we figure out the names of header files and make files
    # for this version of OSX.
    makefile = "platform_#{osx_name}.GNU"
    header = "config-#{osx_name.sub('_','-')}.h"

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
