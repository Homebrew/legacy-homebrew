class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "http://pwhois.org/lft/"
  url "http://pwhois.org/dl/index.who?file=lft-3.73.tar.gz"
  sha256 "3ecd5371a827288a5f5a4abbd8a5ea8229e116fc2f548cee9afeb589bf206114"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cfa83b34c664b238e135577faca0ac0f3c04b135b8e437b3cfdb7243bd7bdf35" => :el_capitan
    sha256 "d4fb11ed0b1045a9b055526c812b76edf5f876e6c4fb7f581c2ed59915165eb9" => :yosemite
    sha256 "a16749d274db27785fb60ce5371e292d324224cf184b7cdba7129bc6088d0a34" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lft -v 2>&1")
  end
end
