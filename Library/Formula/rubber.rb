class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage "https://launchpad.net/rubber/"
  url "https://launchpad.net/rubber/trunk/1.4/+download/rubber-1.4.tar.gz"
  sha256 "824af6142a0e52804de2f80d571c0aade1d0297a7d359a5f1874acbb53c0f0b4"

  head "lp:rubber", :using => :bzr

  bottle do
    sha256 "928de907e2ff3961c72ff71380fd7db0fc072ae526dc77068718b618ce80f5e6" => :yosemite
    sha256 "33e93b904403bccb9a139ac963cbec128d3a23422e3bb69bd31bbe03191a464a" => :mavericks
    sha256 "e7480ca80262718ac62b26c3573c1b7e3091a2ed1766d7f33967f2620911fbc4" => :mountain_lion
  end

  depends_on "texinfo" => :build
  depends_on :tex

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubber --version")
  end
end
