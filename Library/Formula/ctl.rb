require 'formula'

class Ctl < Formula
  homepage 'https://github.com/ampas/CTL'
  url 'http://sourceforge.net/projects/ampasctl/files/ctl/ctl-1.4.1/ctl-1.4.1.tar.gz'
  sha1 '4e31de8e8da144bbc840d97014a8f45e20e398ac'

  depends_on 'ilmbase'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-ilmbase-prefix=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
