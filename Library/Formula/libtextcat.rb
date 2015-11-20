class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "http://software.wise-guys.nl/libtextcat/"
  url "http://software.wise-guys.nl/download/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"

  bottle do
    cellar :any
    revision 1
    sha256 "1a63f24b16949843f6a3f6c17d9467208a471cfa6bf1b193738fa94c2d320f02" => :yosemite
    sha256 "e7880fa731747f117a943fd99bd41da25bae3e6440316d782c4798cf3f55e0b7" => :mavericks
    sha256 "645dab2e1766e0ea0fc3f6bc897e372ca26826a8ca136463ac864da1ddf74202" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (include/"libtextcat/").install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
