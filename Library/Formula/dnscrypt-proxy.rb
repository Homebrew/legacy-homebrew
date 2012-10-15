require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-1.1.0.tar.gz'
  sha256 '73c1042f6ba68dedd89ab518c319f5e46b3536a3c49e697ef9ba504601b26c71'

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
