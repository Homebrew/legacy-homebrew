require 'formula'

class Scamper <Formula
  url 'http://www.wand.net.nz/scamper/scamper-cvs-20110217.tar.gz'
  homepage 'http://www.wand.net.nz/scamper/'
  md5 '10097a4fd00ca90bfe1aca7569b11ca5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
