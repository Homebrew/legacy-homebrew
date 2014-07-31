require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.3.tar.gz'
  sha1 '205d1c11e2b7eb30f5704953152775334098f2e3'

  head 'https://github.com/concurrencykit/ck.git'

  bottle do
    cellar :any
    sha1 "9d7092669ec91a020b06a1e5a5038af9d2888fff" => :mavericks
    sha1 "27a762867fa388d36763292c53d3a795f63855ff" => :mountain_lion
    sha1 "00473fc2ef6ba55498018637a2573972c36e2052" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end
