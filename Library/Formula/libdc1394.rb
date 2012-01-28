require 'formula'

class Libdc1394 < Formula
  url 'http://sourceforge.net/projects/libdc1394/files/libdc1394-2/libdc1394-2.1.3.tar.gz'
  homepage 'http://damien.douxchamps.net/ieee1394/libdc1394/'
  md5 'd8b2cbfae1b329fdeaa638da80427334'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
