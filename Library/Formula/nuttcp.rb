require 'formula'

class Nuttcp < Formula
  homepage 'http://www.nuttcp.net/nuttcp'
  url 'http://www.nuttcp.net/nuttcp/nuttcp-6.1.2.tar.bz2'
  sha1 '329fcc3c0b75db18b7b4d73962992603f9ace9ca'

  bottle do
    cellar :any
    sha1 "95f9e698a06f16689483b342212bf09d61f31b8f" => :yosemite
    sha1 "964e37122ffd9d1208d532c7bcc295a4a22071cb" => :mavericks
    sha1 "7279df49a2e29d9c223cffd1f9cfc4b1a383a740" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "nuttcp-#{version}" => "nuttcp"
    man8.install 'nuttcp.cat' => 'nuttcp.8'
  end
end
