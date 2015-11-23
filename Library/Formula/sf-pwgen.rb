class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://bitbucket.org/anders/sf-pwgen/"
  url "https://bitbucket.org/anders/sf-pwgen/downloads/sf-pwgen-1.3.tar.gz"
  sha256 "0489dace9de7ad65bf545e774dbf67b6d24cecdcbd32fe5d41397140ccf3aa84"

  head "https://bitbucket.org/anders/sf-pwgen", :using => :hg

  bottle do
    cellar :any
    sha256 "2a5f0b9d8c9a951820583b7e4ec115b545252cc2e247f8b35f4ecfdfa3fc4114" => :yosemite
    sha256 "71043a6853a292150f236ac1c83694c492d930ba8f504a487d636027e5ce8302" => :mavericks
    sha256 "5b91f63b28d364f5a09b7d11db9a1b3de1958e858d51f99ed9ce7e235aa74936" => :mountain_lion
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
