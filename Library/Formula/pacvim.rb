class Pacvim < Formula
  homepage "https://github.com/jmoon018/PacVim"
  url "https://github.com/jmoon018/PacVim/archive/v1.1.1.tar.gz"
  sha1 "496ed02edba8dad15ade95352a7c6441f97fdf7a"
  head "https://github.com/jmoon018/PacVim.git"

  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "PREFIX=#{prefix}"
  end
end
