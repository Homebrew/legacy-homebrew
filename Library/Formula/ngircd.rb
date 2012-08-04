require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-19.2.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-19.2.tar.gz'
  sha1 'c97e0409778ef1a4431bec1917b36918171047bc'

  depends_on 'libident'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ident",
                          "--with-openssl",
                          "--with-tcp-wrappers",
                          "--enable-ipv6"
    system "make install"

    system "make -C contrib/MacOSX de.barton.ngircd.plist"
    inreplace "contrib/MacOSX/de.barton.ngircd.plist",
      /\/Library\/Logs/, "#{HOMEBREW_PREFIX}/var/log"

    prefix.install "contrib/MacOSX/de.barton.ngircd.plist"
    (prefix+"de.barton.ngircd.plist").chmod 0644
    false
  end

  def caveats; <<-EOCAVEATS
# Start/Stop ngircd(8) Daemon

If this is your first install, automatically load on login with:
  sudo cp #{prefix}/de.barton.ngircd.plist /Library/LaunchDaemons/
  sudo launchctl load -w /Library/LaunchDaemons/de.barton.ngircd.plist

If this is an upgrade and you already have the #{plist_path.basename} loaded:
  sudo launchctl unload -w /Library/LaunchDaemons/de.barton.ngircd.plist
  sudo cp #{prefix}/de.barton.ngircd.plist /Library/LaunchDaemons/
  sudo launchctl load -w /Library/LaunchDaemons/de.barton.ngircd.plist
EOCAVEATS
  end
end
