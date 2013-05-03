require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.2.1.tar.bz2'
  sha256 '8476b97812d32b88af95e06441a28d8ee7fd92c409124d04591493bd23d5b2fc'

  head 'https://github.com/opendns/dnscrypt-proxy.git', :branch => 'master'

  option "plugins", "Support plugins and install example plugins."

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf", "-if" if build.head?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end
    system "./configure", *args
    system "make install"
  end
end
