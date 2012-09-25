require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'https://github.com/downloads/opendns/dnscrypt-proxy/dnscrypt-proxy-1.1.0.tar.gz'
  head 'https://github.com/opendns/dnscrypt-proxy.git', :branch => 'master'
  sha256 '73c1042f6ba68dedd89ab518c319f5e46b3536a3c49e697ef9ba504601b26c71'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option "plugins", "Support plugins and install example plugins."

  def install
    system "autoreconf", "-if" if build.head?

    configure_args = [ "--prefix=#{prefix}", "--disable-dependency-tracking" ]
    if build.include? "plugins"
      configure_args << "--enable-plugins"
      configure_args << "--enable-relaxed-plugins-permissions"
      configure_args << "--enable-plugins-root"
    end
    system "./configure", *configure_args
    system "make install"
  end
end
