require 'formula'

class Strongswan < Formula
  homepage 'http://www.strongswan.org'
  url 'http://download.strongswan.org/strongswan-5.1.0.tar.bz2'
  sha1 'ee7a9b078b183c138156fba695ddf870f1990748'

  option 'with-curl', 'Build with libcurl based fetcher'
  option 'with-suite-b', 'Build with Suite B support (does not use the IPsec implementation provided by the kernel)'

  depends_on 'vstr'
  depends_on 'openssl' if build.include? 'with-suite-b' or MacOS.version <= :leopard
  depends_on 'curl' => :optional

  def install
    # required for Vstr
    ENV.append 'CFLAGS', '--std=gnu89' if ENV.compiler == :clang
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
      --enable-pubkey
      --enable-revocation
      --enable-socket-default
      --enable-sshkey
      --enable-stroke
      --enable-tools
      --enable-updown
      --enable-unity
      --enable-vstr
      --enable-xauth-generic
    ]
    args << "--enable-curl" if build.with? 'curl'
    args << "--enable-kernel-pfkey" unless build.with? 'suite-b'
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
