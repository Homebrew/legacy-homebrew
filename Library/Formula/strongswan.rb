class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.3.4.tar.bz2"
  sha256 "938ad1f7b612e039f1d32333f4865160be70f9fb3c207a31127d0168116459aa"

  bottle do
    sha256 "909260113bd3eede7c5635ca82665eed2ea92aaa709805f5f7a33ae875948fdd" => :el_capitan
    sha256 "74ded51bf661392c1ffdbdf08e9452471362ff0f871ba3f4bed4ee6ca483bcfd" => :yosemite
    sha256 "897599453b695e96102fa43a0905027043b9d99e6092dacf6c79c25ae1ea1eef" => :mavericks
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
