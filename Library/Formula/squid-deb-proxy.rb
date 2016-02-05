class SquidDebProxy < Formula
  desc "APT repo caching proxy based on Squid."
  homepage "https://launchpad.net/squid-deb-proxy"

  url "http://bazaar.launchpad.net/~squid-deb-proxy-developers/squid-deb-proxy/trunk/tarball/139"
  version "0.8.13"
  sha256 "90e9d749b4d9ed1373199f89cc853a205fa521d84e8dcbf55db0a5b5036bdf05"

  depends_on "squid"

  # assorted changes that should be submitted upstream
  patch :DATA

  def install
    cd "squid-deb-proxy/trunk"

    # fix up issues specific to Homebrew
    inreplace "squid-deb-proxy.conf" do |s|
      # fix paths with the HOMEBREW_PREFIX
      s.gsub! %r{([\s='"])/etc/}, "\\1#{etc}/"
      s.gsub! %r{([\s='"])/var/}, "\\1#{var}/"
    end

    inreplace "init-common.sh" do |s|
      # install should be as the calling user
      s.gsub! /(\binstall\b.*?)(\s+-[og]\s*\S+)+/, "\\1"

      # fix paths with the HOMEBREW_PREFIX
      s.gsub! "/usr/sbin/squid", "#{HOMEBREW_PREFIX}/opt/squid/sbin/squid"
      s.gsub! %r{([\s='"])/etc/}, "\\1#{etc}/"
      s.gsub! %r{([\s='"])/var/}, "\\1#{var}/"
    end

    # pre-installation from debian/rules
    # we take both sets because we're not either distro
    Pathname("mirror-dstdomain.acl").write(
      Pathname("mirror-dstdomain.acl.Debian").binread +
        Pathname("mirror-dstdomain.acl.Ubuntu").binread
    )

    # normal installation called by debian/rules
    system "make", "install", "DESTDIR=#{prefix}"

    # additional installation from debian/squid-deb-proxy.install
    mkdir_p "#{prefix}/usr/share/squid-deb-proxy"
    cp "init-common.sh", "#{prefix}/usr/share/squid-deb-proxy/"

    # produce execution wrapper script
    Pathname("#{sbin}/squid-deb-proxy").write(<<-EOS.undent
      #!/bin/bash

      . '#{opt_prefix}/usr/share/squid-deb-proxy/init-common.sh'
      pre_start

      exec "$SQUID" -f '#{etc}/squid-deb-proxy/squid-deb-proxy.conf' "$@"
      EOS
    )

    # produce placeholder files from debian/squid-deb-proxy.postinst
    # these also serve to prevent the directories from being removed
    user_conf      = "#{etc}/squid-deb-proxy/squid.conf.d/10-default.conf"
    user_networks  = "#{etc}/squid-deb-proxy/allowed-networks-src.acl.d/10-default"
    user_dests     = "#{etc}/squid-deb-proxy/mirror-dstdomain.acl.d/10-default"
    user_blacklist = "#{etc}/squid-deb-proxy/pkg-blacklist.d/10-default"
    Pathname(user_conf).write(<<-EOS.undent
      # #{user_conf}
      #
      # additional Squid configuration
      EOS
    )
    Pathname(user_networks).write(<<-EOS.undent
      # #{user_networks}
      #
      # additional network sources that you want to allow access to the cache

      # example net
      #136.199.8.0/24
      EOS
    )
    Pathname(user_dests).write(<<-EOS.undent
      # #{user_dests}
      #
      # network destinations that are allowed by this cache

      # launchpad personal package archives (disabled by default)
      #ppa.launchpad.net
      #private-ppa.launchpad.net

      # add additional mirror domains here (disabled by default)
      #linux.dropbox.com
      #download.virtualbox.org
      #archive.getdeb.net
      #packages.medibuntu.org
      #dl.google.com
      #repo.steampowered.com
      EOS
    )
    Pathname(user_blacklist).write(<<-EOS.undent
      # #{user_blacklist}
      #
      # packages that should be not allowed for download, one binary packagename
      # per line
      #
      #skype
      EOS
    )
  end

  test do
    # This test should start squid and then check it runs correctly.
    # However, anything further would involve starting the daemon, which is
    # problematic. See the comments in `test do` in the `squid` formula.
    # This *does* at least test the wrapper script.
    system "#{opt_sbin}/squid-deb-proxy", "-v"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/squid-deb-proxy</string>
        <string>-N</string>
        <string>-d 1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end
__END__
--- a/squid-deb-proxy/trunk/squid-deb-proxy.conf	2016-02-04 17:22:07.000000000 -0800
+++ b/squid-deb-proxy/trunk/squid-deb-proxy.conf	2016-02-04 18:52:52.000000000 -0800
# fix "Invalid regular expression ... empty (sub)expression" error
@@ -58,10 +58,10 @@
 refresh_pattern tar.bz2$  129600 100% 129600

 # always refresh Packages and Release files
-refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
-refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims
+refresh_pattern \/(Packages|Sources)(\.bz2|\.gz|\.xz)?$ 0 0% 0 refresh-ims
+refresh_pattern \/Release(\.gpg)?$ 0 0% 0 refresh-ims
 refresh_pattern \/InRelease$ 0 0% 0 refresh-ims
-refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
+refresh_pattern \/(Translation-.*)(\.bz2|\.gz|\.xz)?$ 0 0% 0 refresh-ims

 # handle meta-release and changelogs.ubuntu.com special
 # (fine to have this on debian too)
--- a/squid-deb-proxy/trunk/squid-deb-proxy.conf	2016-02-04 17:22:07.000000000 -0800
+++ b/squid-deb-proxy/trunk/squid-deb-proxy.conf	2016-02-04 18:52:52.000000000 -0800
# allow dumping extra configuration in a directory
@@ -71,6 +71,12 @@
 acl Safe_ports port 80
 acl Safe_ports port 443 563

+
+# include extra configuration at this point
+# before the ACL denies means exceptions can be added
+include /etc/squid-deb-proxy/squid.conf.d/*.conf
+
+
 # only allow ports we trust
 http_access deny !Safe_ports
