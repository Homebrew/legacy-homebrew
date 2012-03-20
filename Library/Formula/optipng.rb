require 'formula'

class Optipng < Formula
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7/optipng-0.7.tar.gz'
  homepage 'http://optipng.sourceforge.net/'
  md5 '9b2f526ce79ea779c7004c7964ee8bcc'

  def install
    system "./configure", "--with-system-zlib", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
