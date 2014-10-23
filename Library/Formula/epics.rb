require "formula"

class Epics < Formula
  homepage "http://www.aps.anl.gov/epics/"
  url "http://www.aps.anl.gov/epics/download/base/baseR3.14.12.4.tar.gz"
  sha1 "3115476795f93b12b2bb62c04bef5a1fa2595e0a"

  def install
    ENV["EPICS_HOST_ARCH"] = `#{buildpath}/startup/EpicsHostArch`.chomp
    inreplace "configure/CONFIG_SITE", "#INSTALL_LOCATION=<fullpathname>", "INSTALL_LOCATION=#{libexec}"
    system "make", "install"
   end

  def caveats; <<-EOS.undent
    Please configure your system to define the following system environment variables:
        EPICS_BASE=#{opt_prefix}/libexec
        EPICS_HOST_ARCH=#{ENV["EPICS_HOST_ARCH"]}
    EOS
  end
end
