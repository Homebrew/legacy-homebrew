require "formula"

class Yash < Formula
  homepage "http://yash.sourceforge.jp/"
  url "http://dl.sourceforge.jp/yash/62651/yash-2.37.tar.gz"
  sha1 "a6ac6fe9434a25a8fd39137a05768aa65076bed6"

  bottle do
    cellar :any
    sha1 "efa6ac2ec264e4efc16394f55839a89753631903" => :yosemite
    sha1 "803be32d90a8ab8fd2812b342be94316c9727dd8" => :mavericks
    sha1 "bffcef7392e6ddeccda732aea313ae3ea7f1e36d" => :mountain_lion
  end

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
