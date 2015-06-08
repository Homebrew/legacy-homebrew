class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "http://www.nuttcp.net/nuttcp"
  url "http://www.nuttcp.net/nuttcp/nuttcp-6.1.2.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nuttcp/nuttcp_6.1.2.orig.tar.gz"
  sha256 "4edfa66a6d03fbd8a5c030a8aad33786945d83455b395486dba592e8a2312a87"

  bottle do
    cellar :any
    sha1 "95f9e698a06f16689483b342212bf09d61f31b8f" => :yosemite
    sha1 "964e37122ffd9d1208d532c7bcc295a4a22071cb" => :mavericks
    sha1 "7279df49a2e29d9c223cffd1f9cfc4b1a383a740" => :mountain_lion
  end

  def install
    system "make", "APP=nuttcp",
           "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "nuttcp"
    man8.install "nuttcp.cat" => "nuttcp.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuttcp -V")
  end
end
