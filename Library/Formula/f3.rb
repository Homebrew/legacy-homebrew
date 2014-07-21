require "formula"

class F3 < Formula
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v3.0.tar.gz"
  sha1 "9e0d2ddec98c09be17b5d343bd6d5fac2606a963"

  def install
    system "make mac"
    bin.install "f3read", "f3write"
  end
end
