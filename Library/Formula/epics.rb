require "formula"

# brew audit reports
# * Non-executables were installed to "/usr/local/Cellar/epics/3.14.12.4/bin"
#
# This is OK (and required) for EPICS build system. EPICS does not come with
# end-user eecutables. The executables in the prefix/bin are needed by other
# libraries.

class Epics < Formula
  homepage "http://www.aps.anl.gov/epics/"
  url "http://www.aps.anl.gov/epics/download/base/baseR3.14.12.4.tar.gz"
  sha1 "3115476795f93b12b2bb62c04bef5a1fa2595e0a"
  version "3.14.12.4"

  def install
    ENV['EPICS_HOST_ARCH'] = %x[#{buildpath}/startup/EpicsHostArch].chomp
    inreplace "configure/CONFIG_SITE", "#INSTALL_LOCATION=<fullpathname>", "INSTALL_LOCATION=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Please configure your system to define the following system environment variables:

        EPICS_BASE=#{prefix}
        EPICS_HOST_ARCH=#{ENV['EPICS_HOST_ARCH']}

    EOS
  end

end
