class Cifer < Formula
  desc "Work on automating classical cipher cracking in C"
  homepage "https://code.google.com/p/cifer/"
  url "https://cifer.googlecode.com/files/cifer-1.2.0.tar.gz"
  sha256 "436816c1f9112b8b80cf974596095648d60ffd47eca8eb91fdeb19d3538ea793"

  bottle do
    cellar :any
    sha256 "bde7d97d9ef2a07c481ff8c5ec717fb2ec455fdef864db2a1a7b3056aa1934d2" => :yosemite
    sha256 "f4e2f4024a8daf1e2a1fc071113947561c803503fa242b7df7970e8979cf10be" => :mavericks
    sha256 "8e7b415f5012c001c47484a29e55c608b51e82f5fc5be41787b061765e405d64" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    assert_match /#{version}/, pipe_output("#{bin}/cifer")
  end
end
