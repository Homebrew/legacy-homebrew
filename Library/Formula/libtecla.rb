require "formula"

class Libtecla < Formula
  homepage "http://www.astro.caltech.edu/~mcs/tecla/index.html"
  url "http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha1 "1c2ca66c16deea59cde6fff53a5cfb9a02659ffc"

  bottle do
    cellar :any
    sha1 "d4148dea590822dbd6b801decdaa4ba9cd88cf02" => :yosemite
    sha1 "7158c356aa224f096a93cafdc8f01fa238471b9b" => :mavericks
    sha1 "515484afb0f5e3eea75a775361ce9b8059cb5a54" => :mountain_lion
  end

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
