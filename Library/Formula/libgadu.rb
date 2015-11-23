class Libgadu < Formula
  desc "Library for ICQ instant messenger protocol"
  homepage "http://libgadu.net/"
  url "https://github.com/wojtekka/libgadu/releases/download/1.12.1/libgadu-1.12.1.tar.gz"
  sha256 "a2244074a89b587ba545b5d87512d6eeda941fec4a839b373712de93308d5386"

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
