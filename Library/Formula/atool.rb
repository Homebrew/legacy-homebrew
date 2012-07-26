require 'formula'

class Atool < Formula
  homepage 'http://www.nongnu.org/atool/'
  url 'http://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz'
  md5 'e0aa006decbc6484b9dba2879f1bb9f0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
