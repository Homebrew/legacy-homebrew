class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.4-rbsec.tar.gz"
  version "1.11.4"
  sha256 "25720c0caf25a1a81841417658201030ac17c20be59e14dc466c79a92c7bfe10"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "b885f2a0a26d764eb80634ffd3834738b498a355704f5f6303f365b4208ae2b2" => :el_capitan
    sha256 "90f200a5d92d4d2561a31474ca5a17b1014a1945203c9f670c027ef8b67139bd" => :yosemite
    sha256 "b74ae765db7d73449c4a9231bdb90554171befc13b60c6813bc7069acb039b5d" => :mavericks
  end

  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
