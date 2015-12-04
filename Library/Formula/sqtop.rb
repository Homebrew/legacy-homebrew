class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha256 "eae4c8bc16dbfe70c776d990ecf14328acab0ed736f0bf3bd1647a3ac2f5e8bf"

  bottle do
    cellar :any
    sha256 "29291fedaa06b7b680e44e1b82f643f7ddffc67435312b7c2f3654df0728cb8b" => :yosemite
    sha256 "f1ab5347b698d2e1221a5111fec52022159afc898e5ad7a5318becb23cd35543" => :mavericks
    sha256 "39b62e9a679009e6dc0106a6e63d229b6c310d222966a0f69b90ec388926102e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/sqtop --help")
  end
end
