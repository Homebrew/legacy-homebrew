class Memo < Formula
  url "http://www.getmemo.org/memo-1.5.tar.gz"
  bottle do
    cellar :any
    sha1 "824504a78e8f84ee824e62b35172bb15ad8d7d4d" => :yosemite
    sha1 "5bf25a80b56621ae3a5f0e4203f86921f545e128" => :mavericks
    sha1 "cc76689fd90ea7bc8d2741439fbb4ae4e7243aa2" => :mountain_lion
  end

  homepage "http://www.getmemo.org"
  sha1 "3e047b09e91d695f1767d1dd6d179732c07a5759"

  def install
    bin.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["MEMO_PATH"] = testpath/"memos"
    system "#{bin}/memo", "-a",  "Lorem ipsum dolor sit amet."
  end
end
