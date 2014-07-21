require 'formula'

class Optipng < Formula
  homepage 'http://optipng.sourceforge.net/'
  head 'http://optipng.hg.sourceforge.net/hgweb/optipng/optipng'
  url 'https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.5/optipng-0.7.5.tar.gz'
  sha1 '30b6c333d74fc0f5dc83004aace252fa3321368b'

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
