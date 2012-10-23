require 'formula'

class VpncScript < Formula
  url 'http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/a92baacc79914de9d29704f0fd2ac6fe7a0cd7c4:/vpnc-script'
  sha1 'ee76aa0adc085784871cd55e2a4ab70310d848b8'
end

class Openconnect < Formula
  homepage 'http://www.infradead.org/openconnect.html'
  url 'ftp://ftp.infradead.org/pub/openconnect/openconnect-4.07.tar.gz'
  sha1 '6ed84bda36578b4eb67beb4b39f03aec90270a77'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def install
    VpncScript.new.brew { etc.install Dir['*'] }
    chmod 0755, "#{etc}/vpnc-script"

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    OpenConnect requires the use of a TUN/TAP driver.

    You can download one at http://tuntaposx.sourceforge.net/
    and install it prior to running OpenConnect.
    EOS
  end
end
