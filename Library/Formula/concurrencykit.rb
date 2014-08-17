require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.3.tar.gz'
  sha1 '205d1c11e2b7eb30f5704953152775334098f2e3'

  head 'https://github.com/concurrencykit/ck.git'

  bottle do
    cellar :any
    sha1 "e6bc5b3cee4bfbbe493d33953d280d03a398661c" => :mavericks
    sha1 "ff04b2b4ba7d4275f2cf13981f2bb7620e62fbd2" => :mountain_lion
    sha1 "6fe202a825da5dd1254c5fc750c495c25661df44" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end
