class Libgadu < Formula
  desc "Library for ICQ instant messenger protocol"
  homepage "http://libgadu.net/"
  url "https://github.com/wojtekka/libgadu/releases/download/1.12.1/libgadu-1.12.1.tar.gz"
  sha1 "a41435c0ae5dd5e7e3b998915639a8288398f86e"

  bottle do
    cellar :any
    sha1 "4c48ff84a392640d330c61baaeebc1fd5d0def6c" => :yosemite
    sha1 "794bc221f54955506c6c8b45333f4cfc801a289b" => :mavericks
    sha1 "8c9b7e31ba9c250cdf6a86a164c38d9669ae52d4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
