require 'formula'

class Libsndfile <Formula
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.20.tar.gz'
  homepage 'http://www.mega-nerd.com/libsndfile/'
  md5 'e0553e12c7a467af44693e95e2eac668'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
