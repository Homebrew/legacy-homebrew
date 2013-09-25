require 'formula'

class ProxychainsNg < Formula
  homepage 'https://sourceforge.net/projects/proxychains-ng'
  url 'http://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.6.tar.bz2'
  sha1 '8f1fb3fa4c391cd2e07f0a7dd0bc4cc55550cb6b'

  head 'https://github.com/rofl0r/proxychains-ng.git'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make"
    system "make install"
    system "make install-config"
  end
end
