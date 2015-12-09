class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "http://frei0r.dyne.org"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.4.tar.gz"
  sha256 "8470fcabde9f341b729be3be16385ffc8383d6f3328213907a43851b6e83be57"

  bottle do
    cellar :any_skip_relocation
    sha256 "960aa91d50697be5587a0124910d4c603354c3dfb660f9fc7dead6ea36d2140c" => :el_capitan
    sha256 "66426f87d88f4ea884ac74ba0a90d30433c4a00fc7295299bd15a960ef8807e3" => :yosemite
    sha256 "9e75c7883faa766b20f1d19c85eff4556039a49e65847806ef34cdae89f1c1ca" => :mavericks
    sha256 "a20918ebf08da3636deb4bb4c3bacaf395186f2bf88685ad8380d665e7402e24" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
