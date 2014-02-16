require 'formula'

class Scamper < Formula
  homepage 'http://www.caida.org/tools/measurement/scamper/'
  url 'http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20140122.tar.gz'
  sha1 'a9ede92a49d8e3433cb909a1467a51320d35c5af'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
