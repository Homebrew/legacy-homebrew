require 'formula'

class DnscryptProxy < Formula
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-1.1.0.tar.gz'
  head 'https://github.com/opendns/dnscrypt-proxy.git', :branch => 'master'
  homepage 'http://dnscrypt.org'
  sha256 '73c1042f6ba68dedd89ab518c319f5e46b3536a3c49e697ef9ba504601b26c71'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option "plugins", "Support plugins and install example plugins."

  def install
    if build.head?
      system "autoreconf", "-if"
    end

    if build.include? "plugins"
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
      "--enable-plugins", "--enable-relaxed-plugins-permissions", "--enable-plugins-root"
    else
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    end
    system "make install"
  end
end
