require 'formula'

class Strongswan < Formula
  homepage 'https://www.strongswan.org'
  url 'https://download.strongswan.org/strongswan-5.3.0.tar.bz2'
  sha1 '6d83222143ff4dabbc667e9b1725cac55c546826'

  bottle do
    sha256 "ec1068ac5a7d24f1ed98869e43a2d1c25cbd64d4696e680c91250d89bad89832" => :yosemite
    sha256 "2109c92e70fa30f788961f7821ddacce96f2dc0f94b2d85fb975bdc82e0ed542" => :mavericks
    sha256 "599a83b29ab463c09b247c96492432c353403b1aeb95f636bd68de542fa9cd5d" => :mountain_lion
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
