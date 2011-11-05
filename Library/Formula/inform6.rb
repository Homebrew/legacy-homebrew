require 'formula'

class Inform6 < Formula
  url 'http://ifarchive.flavorplex.com/if-archive/infocom/compilers/inform6/source/inform-6.31.1.tar.gz'
  homepage 'http://www.inform-fiction.org/inform6.html'
  md5 '02e64fc13c06a888a6c0f97974e2c02c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
