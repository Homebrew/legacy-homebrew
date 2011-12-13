require 'formula'

class Xtermcontrol < Formula
  url 'http://thrysoee.dk/xtermcontrol/xtermcontrol-2.10.tar.gz'
  homepage 'http://thrysoee.dk/xtermcontrol/'
  md5 'd108e24d0a8ddc1b58b37f559314eb76'
  head 'https://github.com/JessThrysoee/xtermcontrol.git'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
