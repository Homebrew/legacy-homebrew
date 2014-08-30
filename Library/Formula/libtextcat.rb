require 'formula'

class Libtextcat < Formula
  homepage 'http://software.wise-guys.nl/libtextcat/'
  url 'http://software.wise-guys.nl/download/libtextcat-2.2.tar.gz'
  sha1 'e98d7149d6a20fdbb58cc0b79cb5e3f95ae304e4'

  bottle do
    cellar :any
    sha1 "690077cff18427cb7d116a36eb3852bb5af86265" => :mavericks
    sha1 "9a28c9360d649e2f17850667249f8ed428cfce78" => :mountain_lion
    sha1 "d285c6f6047a4fbeb61f1aa039402f89c4a72fd2" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (include/'libtextcat/').install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
