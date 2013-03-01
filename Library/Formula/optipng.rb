require 'formula'

class Optipng < Formula
  homepage 'http://optipng.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.4/optipng-0.7.4.tar.gz'
  sha1 'dcde17501cfb7a425b6cc23cfed482bbfd4867bb'

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
