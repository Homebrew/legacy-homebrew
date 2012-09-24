require 'formula'

class Optipng < Formula
  homepage 'http://optipng.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.3/optipng-0.7.3.tar.gz'
  sha1 'c5dd2c688820f34fb6973d109ca880a77141cd31'

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
