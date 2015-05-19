class SfPwgen < Formula
  homepage "https://bitbucket.org/anders/sf-pwgen/"
  url "https://bitbucket.org/anders/sf-pwgen/downloads/sf-pwgen-1.3.tar.gz"
  sha256 "0489dace9de7ad65bf545e774dbf67b6d24cecdcbd32fe5d41397140ccf3aa84"

  head "https://bitbucket.org/anders/sf-pwgen", :using => :hg

  bottle do
    cellar :any
    sha1 "94cd1487d44fc74a8f8581889cfc91d4ebe16106" => :mavericks
    sha1 "6ae2fe533a617fca26f5bf665467f5bb1885f96b" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
