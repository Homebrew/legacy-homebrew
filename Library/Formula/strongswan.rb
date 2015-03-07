require 'formula'

class Strongswan < Formula
  homepage 'http://www.strongswan.org'
  url 'http://download.strongswan.org/strongswan-5.2.2.tar.bz2'
  sha1 '5dcf6e8e50e11e4009375fda5ce2b49049123e18'

  bottle do
    sha1 "bcceab4dccbbaef7815b0e4b0c5fd800c9323edd" => :yosemite
    sha1 "7ecdc03048bdb90143588c229a3d5422af2feae2" => :mavericks
    sha1 "8c1bb11c6d21f5d4c80a43fbffdf5ac432eaaa3f" => :mountain_lion
  end

  option 'with-curl', 'Build with libcurl based fetcher'
  option 'with-suite-b', 'Build with Suite B support (does not use the IPsec implementation provided by the kernel)'

  depends_on 'openssl'
  depends_on 'curl' => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --disable-defaults
      --enable-charon
      --enable-cmd
      --enable-constraints
      --enable-eap-identity
      --enable-eap-md5
      --enable-eap-gtc
      --enable-eap-mschapv2
      --enable-ikev1
      --enable-ikev2
      --enable-kernel-pfroute
      --enable-nonce
      --enable-openssl
      --enable-osx-attr
      --enable-pem
      --enable-pgp
      --enable-pkcs1
      --enable-pkcs8
      --enable-pki
      --enable-pubkey
      --enable-revocation
      --enable-scepclient
      --enable-socket-default
      --enable-sshkey
      --enable-stroke
      --enable-swanctl
      --enable-updown
      --enable-unity
      --enable-xauth-generic
    ]
    args << "--enable-curl" if build.with? 'curl'
    args << "--enable-kernel-pfkey" if build.without? 'suite-b'
    args << "--enable-kernel-libipsec" if build.with? 'suite-b'

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    msg = <<-EOS.undent
      strongSwan's configuration files are placed in:
        #{etc}

      You will have to run both 'ipsec' and 'charon-cmd' with 'sudo'.
    EOS
    if build.with? 'suite-b'
      msg += <<-EOS.undent

        If you previously ran strongSwan without Suite B support it might be
        required to execute 'sudo sysctl -w net.inet.ipsec.esp_port=0' in order
        to receive packets.
      EOS
    end
    return msg
  end
end
