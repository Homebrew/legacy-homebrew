require 'formula'

class Scamper <Formula
  url 'http://www.wand.net.nz/scamper/scamper-cvs-20101102.tar.gz'
  homepage 'http://www.wand.net.nz/scamper/'
  md5 'd2540fe85c56a3ea146ba4d10525433c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
