require 'formula'

class Scamper < Formula
  homepage 'http://www.caida.org/tools/measurement/scamper/'
  url 'http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20140404.tar.gz'
  sha1 '26907d8a0c92471bd9789724b8547a58864be5fb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
