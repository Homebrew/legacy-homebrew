class Memo < Formula
  url "http://www.getmemo.org/memo-1.4.tar.gz"
  homepage "http://www.getmemo.org"
  sha1 "0b4c1b22fac0644b54d7de1e89cb20a54c8fff25"
  version "1.4"

  depends_on "make"

  def install
    system "make", "install"
  end
end