require 'formula'

class Libbs2b <Formula
  url 'http://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz'
  homepage 'http://bs2b.sourceforge.net/'
  md5 '2c3351f1785364107aabc44f67d33d84'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile'
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make install"
  end
end
