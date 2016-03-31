class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.4.0.tar.bz2"
  sha256 "f8288faaea6a9cd8a7d413c0b76b7922be5da3dfcd01fd05cb30d2c55d3bbe89"

  bottle do
    sha256 "62939c3cfbe8c4cb29713f8e9d62b07409d728e3f8d13e02934e0b6c0e13e22c" => :el_capitan
    sha256 "5068c35ac8bd7ed6b0cec8609533916253dd3297c656045cadf868da6c661260" => :yosemite
    sha256 "0b7e27871489c6fef1a1d23fbfe35292961748ce8e11dc13625a4294a82f8e3e" => :mavericks
  end

  head do
    url "https://git.strongswan.org/strongswan.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "gettext" => :build
    depends_on "bison" => :build
  end

  option "with-curl", "Build with libcurl based fetcher"
  option "with-suite-b", "Build with Suite B support (does not use the IPsec implementation provided by the kernel)"

  depends_on "openssl"
  depends_on "curl" => :optional

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
    args << "--enable-curl" if build.with? "curl"

    if build.with? "suite-b"
      args << "--enable-kernel-libipsec"
    else
      args << "--enable-kernel-pfkey"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  def caveats
    msg = <<-EOS.undent
      strongSwan's configuration files are placed in:
        #{etc}

      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
    if build.with? "suite-b"
      msg += <<-EOS.undent

        If you previously ran strongSwan without Suite B support it might be
        required to execute "sudo sysctl -w net.inet.ipsec.esp_port=0" in order
        to receive packets.
      EOS
    end
    msg
  end

  test do
    system "#{bin}/ipsec", "--version"
    system "#{bin}/charon-cmd", "--version"
  end
end
