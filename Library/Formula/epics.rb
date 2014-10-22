require "formula"

# brew audit reports
# * Non-executables were installed to "/usr/local/Cellar/epics/3.14.12.4/bin"
#
# This is OK (and required) for EPICS build system. EPICS does not come with executables,
# it's a framework to make ones.

class Epics < Formula
  homepage "http://www.aps.anl.gov/epics/"
  url "http://www.aps.anl.gov/epics/download/base/baseR3.14.12.4.tar.gz"
  sha1 "3115476795f93b12b2bb62c04bef5a1fa2595e0a"
  version "3.14.12.4"

  def install
    host_arch = `#{buildpath}/startup/EpicsHostArch`
    host_arch = host_arch.strip

    ohai "Configuring INSTALL_LOCATION to point to #{prefix}"
    inreplace "configure/CONFIG_SITE", "#INSTALL_LOCATION=<fullpathname>", "INSTALL_LOCATION=#{prefix}"

    ohai "Building EPICS base #{version} for #{host_arch}, this might take a while..."
    system "make install"
    ohai "EPICS base #{version} built successfully.\n"

    ohai "Creating an EPICS root symlink"
    epics_root = "#{HOMEBREW_PREFIX}/#{name}"
    system "ln -fs #{HOMEBREW_PREFIX}/Cellar/#{name} #{epics_root}"

    ohai ""
    ohai "Please configure your system to define the following system environment variables:"
    ohai "\tEPICS_BASE=#{epics_root}/#{version}"
    ohai "\tEPICS_HOST_ARCH=#{host_arch}"
  end

end
