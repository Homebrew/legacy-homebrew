require 'formula'

class Optipng < Formula
  homepage 'http://optipng.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.1/optipng-0.7.1.tar.gz'
  sha1 'f71ae8c83ffb610c774f454c0f4e47cc7385a545'

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
