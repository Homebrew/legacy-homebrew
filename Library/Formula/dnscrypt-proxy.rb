require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-1.2.0.tar.gz'
  sha256 '02ae6360887995d73d4c02ea7fa0cc8cad4a4de61f89c2fd68674a65f427b333'

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
