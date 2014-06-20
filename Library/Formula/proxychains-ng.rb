require 'formula'

class ProxychainsNg < Formula
  homepage 'https://sourceforge.net/projects/proxychains-ng'
  url 'https://downloads.sourceforge.net/project/proxychains-ng/proxychains-4.7.tar.bz2'
  sha1 '5e5b10009f785434ebdbd7ede5a79efee4e59c5a'

  head 'https://github.com/rofl0r/proxychains-ng.git'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"
    system "make"
    system "make install"
    system "make install-config"
  end
end
