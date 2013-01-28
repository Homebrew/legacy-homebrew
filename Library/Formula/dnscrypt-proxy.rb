require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'https://github.com/opendns/dnscrypt-proxy/archive/1.2.0.tar.gz'
  sha256 'ad2cd0ecd3b8650877ee54f31cc8d38474c5da7a70c6fb417da856835713662b'

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
