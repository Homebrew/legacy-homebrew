require 'formula'

class ProxychainsNg < Formula
  homepage 'https://sourceforge.net/projects/proxychains-ng'
  url 'http://surfnet.dl.sourceforge.net/project/proxychains-ng/proxychains-4.5.tar.bz2'
  sha1 'b7d85c6dfae83ec50a92c232f674231192f1ca33'

  head 'https://github.com/rofl0r/proxychains-ng.git'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make"
    system "make install"
    system "make install-config"
  end
end
