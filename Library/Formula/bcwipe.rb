require 'formula'

class Bcwipe < Formula
  url 'http://www.jetico.com/linux/BCWipe-1.9-6.tar.gz'
  homepage 'http://www.jetico.com/linux/bcwipe-help/wu_intro.htm'
  md5 'abe1ddf92284d585acf43d7e2d8b1593'

  def install
    ENV.gcc_4_0_1
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
