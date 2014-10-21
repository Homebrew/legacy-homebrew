require 'formula'

class Libtextcat < Formula
  homepage 'http://software.wise-guys.nl/libtextcat/'
  url 'http://software.wise-guys.nl/download/libtextcat-2.2.tar.gz'
  sha1 'e98d7149d6a20fdbb58cc0b79cb5e3f95ae304e4'

  bottle do
    cellar :any
    revision 1
    sha1 "6d8cb21017710ede4222b52333ce7e77f83b950f" => :yosemite
    sha1 "8a025923d5343b538b1147ea2242efdbf70dc4b5" => :mavericks
    sha1 "975626aabfedfd7e3cf48025f26878e3b7fe78e3" => :mountain_lion
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
