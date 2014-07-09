require 'formula'

class Strongswan < Formula
  homepage 'http://www.strongswan.org'
  url 'http://download.strongswan.org/strongswan-5.2.0.tar.bz2'
  sha1 'f907d4ac9e4353db888bbf856e959a05c08a70fc'

  bottle do
    sha1 "7a63c925dde5195c98e3e63dc3fb6eb963eac106" => :mavericks
    sha1 "f4e35b174358d712e8fab4bee12a7a864860b05c" => :mountain_lion
    sha1 "a6006954a5d396d2822212bec774f7a4b863e19f" => :lion
  end

  option 'with-curl', 'Build with libcurl based fetcher'
  option 'with-suite-b', 'Build with Suite B support (does not use the IPsec implementation provided by the kernel)'

  depends_on 'openssl' if build.with? "suite-b" or MacOS.version <= :leopard
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
