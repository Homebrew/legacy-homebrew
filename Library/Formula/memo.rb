class Memo < Formula
  homepage "http://www.getmemo.org"
  url "http://www.getmemo.org/memo-1.6.tar.gz"
  sha256 "08e32f7eee35c24a790eb886fdde9e86c4ef58d2a3059df95fd3a55718f79e96"
  head "https://github.com/nrosvall/memo.git"

  bottle do
    cellar :any
    sha1 "824504a78e8f84ee824e62b35172bb15ad8d7d4d" => :yosemite
    sha1 "5bf25a80b56621ae3a5f0e4203f86921f545e128" => :mavericks
    sha1 "cc76689fd90ea7bc8d2741439fbb4ae4e7243aa2" => :mountain_lion
  end

  def install
    bin.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["MEMO_PATH"] = testpath/"memos"
    system "#{bin}/memo", "-a",  "Lorem ipsum dolor sit amet."
  end
end
