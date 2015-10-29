class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "http://frei0r.dyne.org"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.4.tar.gz"
  sha256 "8470fcabde9f341b729be3be16385ffc8383d6f3328213907a43851b6e83be57"

  bottle do
    cellar :any_skip_relocation
    sha256 "960aa91d50697be5587a0124910d4c603354c3dfb660f9fc7dead6ea36d2140c" => :el_capitan
    sha1 "dfbdc10c72316e888f6b0ecd3716d57fd7a8d1fc" => :yosemite
    sha1 "457dc6f5d0786b960715da5ee5f3e426380c34c3" => :mavericks
    sha1 "2b58483d2b4bb690b852674d3319664c91a62276" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
