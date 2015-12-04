class Libgadu < Formula
  desc "Library for ICQ instant messenger protocol"
  homepage "http://libgadu.net/"
  url "https://github.com/wojtekka/libgadu/releases/download/1.12.1/libgadu-1.12.1.tar.gz"
  sha256 "a2244074a89b587ba545b5d87512d6eeda941fec4a839b373712de93308d5386"

  bottle do
    cellar :any
    sha256 "4c611f1aa42aa415e0e8b3880a17536b37d3e5760ec0b8e7f81039d65c032d74" => :yosemite
    sha256 "a125d428b27a849db24ce63ece66eb43de5b5ba5fb092e464628ba0b320872f4" => :mavericks
    sha256 "77d315541e0bb563fdf9185e32a3bfb4661bbce4781853e1d66c9802ec7599e2" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
