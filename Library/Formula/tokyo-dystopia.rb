require 'formula'

class TokyoDystopia < Formula
  homepage 'http://fallabs.com/tokyodystopia/'
  url 'http://fallabs.com/tokyodystopia/tokyodystopia-0.9.15.tar.gz'
  sha1 '525a44e517ca9594d28fed111e2d103fe6fbf440'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
