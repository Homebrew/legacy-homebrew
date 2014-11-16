require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.4.tar.gz'
  sha1 'bfddebf5af1056ddab1345711e5836563131a252'

  head 'https://github.com/concurrencykit/ck.git'

  bottle do
    cellar :any
    sha1 "86056c5005d9d4d231d2b4603415ef3f9258afd7" => :mavericks
    sha1 "a972444147a7621158474c867eca0def9da131ed" => :mountain_lion
    sha1 "949f89c08cac441c9e2153a01237941fd45ec658" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end
