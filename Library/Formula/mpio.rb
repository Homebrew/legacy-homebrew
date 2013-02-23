require 'formula'

class Mpio < Formula
  homepage 'https://github.com/frsyuki/mpio'
  url 'https://github.com/downloads/frsyuki/mpio/mpio-0.3.7.tar.gz'
  sha1 '2c75a7ad0d0e00e9463f768fa4b579626bf65096'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
