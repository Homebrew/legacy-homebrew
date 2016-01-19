class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "http://www.inmon.com/technology/sflowTools.php"
  url "http://www.inmon.com/bin/sflowtool-3.35.tar.gz"
  sha256 "65ee9880bcc46014e5d8deb46dd52ef760e6ec4e2034796b9681b2da3d74393a"

  bottle do
    cellar :any
    sha256 "e650482fea249a2e4ab05286b38f8e569709cf31fb20af020a4cfd5f5695e9d8" => :yosemite
    sha256 "a7a7b98db64cea2cdbed7cecc58a2051e6be0b1c1fa6cb3b8bef38dae595ab9c" => :mavericks
    sha256 "0cb23bdf819892e4d6aaa34f14b3859df7d41694748ef7fd41827e8591b411eb" => :mountain_lion
  end

  resource "scripts" do
    url "http://www.inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    (prefix/"contrib").install resource("scripts")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sflowtool -h 2>&1")
  end
end
