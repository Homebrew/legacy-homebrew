require "formula"

class Libtecla < Formula
  homepage "http://www.astro.caltech.edu/~mcs/tecla/index.html"
  url "http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha1 "1c2ca66c16deea59cde6fff53a5cfb9a02659ffc"

  bottle do
    cellar :any
    sha1 "d9e5da2740a39ddb9ef8a98b8c4cf0f779ab5741" => :yosemite
    sha1 "e2bd07ac82c62735da70bdd7126f7afef8f7da95" => :mavericks
    sha1 "cfe81b793c6a6f7a42b438862acd4f2872d21e27" => :mountain_lion
  end

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
