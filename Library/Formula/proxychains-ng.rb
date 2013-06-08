require 'formula'

class ProxychainsNG < Formula
  url 'http://surfnet.dl.sourceforge.net/project/proxychains-ng/proxychains-4.5.tar.bz2'
  homepage 'https://sourceforge.net/projects/proxychains-ng'
  md5 '2a83ef208499a208ea507e8dc054b901'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make"
    system "make install"
    system "make install-config"
  end

end
