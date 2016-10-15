require "formula"

class Charybdis < Formula
  homepage "http://atheme.org/projects/charybdis.html"
  url "https://github.com/atheme/charybdis/archive/charybdis-3.4.2.tar.gz"
  sha1 "be483b3423ead000e67bb7fb6bac0ac1baf647a3"
  head "https://github.com/atheme/charybdis.git"

  fails_with :clang do
    build 600
    cause <<-EOS.undent
      There is a pull request on github for this:
      <https://github.com/atheme/charybdis/issues/40>
      EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
