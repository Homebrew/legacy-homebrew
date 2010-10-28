require 'formula'

class Mcl <Formula
  version '10-201'
  url 'http://micans.org/mcl/src/mcl-10-201.tar.gz'
  homepage 'http://micans.org/mcl'
  md5 '9e8aecb9011560b9c3e55fe0f2d1e791'

  def install
    bin.mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-blast"
    system "make install"
  end
end
