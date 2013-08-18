require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.3.3.tar.bz2'
  sha256 'd9aca5253b9fe0fd0bb756201e837d3b723c091e5be0eb3a81cf5432cedaec47'

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
