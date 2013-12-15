require 'formula'

class Scamper < Formula
  homepage 'http://www.caida.org/tools/measurement/scamper/'
  url 'http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20130824.tar.gz'
  sha1 'c3d5c5bb28fd39020a13d9d7be25e4e5ac0cb05e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
