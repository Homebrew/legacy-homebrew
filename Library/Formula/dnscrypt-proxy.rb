require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.3.0.tar.bz2'
  sha256 '211ee2d75acd631b09d012229c73654c2302234d73c9f12425e1c906520dc7c5'

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
