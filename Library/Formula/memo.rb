class Memo < Formula
  url "http://www.getmemo.org/memo-1.4.tar.gz"
  homepage "http://www.getmemo.org"
  sha1 "0b4c1b22fac0644b54d7de1e89cb20a54c8fff25"


  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "memo"
    man1.install "memo.1"
    prefix.install
  end


  test do
    system "#{bin}/memo", "-a", "Lorem ipsum dolor sit amet."
    system "#{bin}/memo", "-m", "1"
    system "#{bin}/memo", "-d", "1"
  end
end
