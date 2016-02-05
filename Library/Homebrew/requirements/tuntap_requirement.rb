require "requirement"

class TuntapRequirement < Requirement
  fatal true
  default_formula "tuntap"
  cask "tuntap"
  satisfy(:build_env => false) { self.class.binary_tuntap_installed? || Formula["tuntap"].installed? }

  def self.binary_tuntap_installed?
    File.exist?("/Library/Extensions/tun.kext") && File.exist?("/Library/Extensions/tap.kext")
    File.exist?("/Library/LaunchDaemons/net.sf.tuntaposx.tun.plist")
    File.exist?("/Library/LaunchDaemons/net.sf.tuntaposx.tap.plist")
  end
end
