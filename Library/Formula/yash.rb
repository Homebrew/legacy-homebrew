require "formula"

class Yash < Formula
  homepage "http://yash.sourceforge.jp/"
  url "http://dl.sourceforge.jp/yash/60930/yash-2.36.tar.xz"
  sha1 "da034f893bf34e3851a93e8512f3fb027e59f0f5"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-alias",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--disable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
