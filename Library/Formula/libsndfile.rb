require 'formula'

class Libsndfile <Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.20.tar.gz'
  md5 'e0553e12c7a467af44693e95e2eac668'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
