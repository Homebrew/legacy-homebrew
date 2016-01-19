class Memo < Formula
  desc "Note-taking and to-do software"
  homepage "http://www.getmemo.org"
  url "http://www.getmemo.org/memo-1.6.tar.gz"
  sha256 "08e32f7eee35c24a790eb886fdde9e86c4ef58d2a3059df95fd3a55718f79e96"
  head "https://github.com/nrosvall/memo.git"

  bottle do
    cellar :any
    sha256 "841ec3aa9b83f218069c2035c4818fcf3da6ae2c137e94ac446874eeb9719e41" => :yosemite
    sha256 "e771214c2f839a58e329c986461810a89e259739ee24b209c6397191d2c2bb21" => :mavericks
    sha256 "967b7a7f27726310aefac3a109879281f0de0eac010e448deab6ef7670ee7c29" => :mountain_lion
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
