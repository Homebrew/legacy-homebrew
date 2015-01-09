class Memo < Formula
  homepage "http://www.getmemo.org/"
  url "https://github.com/nrosvall/memo/archive/v1.5.tar.gz"
  sha1 "b71aaef150c4924006e76af3e3f813336297b649"

  def install
    system "make"
    bin.install "memo"
    man1.install "memo.1"
  end

  test do
    # Print memo version number and exit
    system "#{bin}/memo", "-V"
  end
end
