class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage 'https://www.strongswan.org'
  url 'https://download.strongswan.org/strongswan-5.3.1.tar.bz2'
  sha256 "83fa7b004e65356ff5bb755d9d0e03901d578a99e90b6328a350a4335a32f6de"

  bottle do
    sha256 "78c124b46d7409d91d8f19a256a51ee584f862ae9c8f5b19ed4049486df1af20" => :yosemite
    sha256 "f9c7fc1b920a7fde85dd817c7501e2727a964872913ebfccc903545debc3665c" => :mavericks
    sha256 "b10aaf7f4d09d9876a237832733fdd56c804962e2931ac002a6f0de89e0bd244" => :mountain_lion
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
      --enable-eap-gtc
      --enable-eap-identity
      --enable-eap-md5
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
      --enable-unity
      --enable-updown
      --enable-x509
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
