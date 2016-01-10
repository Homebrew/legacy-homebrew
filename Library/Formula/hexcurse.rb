class Hexcurse < Formula
  desc "Ncurses-based console hex editor"
  homepage "https://github.com/LonnyGomes/hexcurse"
  url "https://github.com/LonnyGomes/hexcurse/archive/v1.60.0.tar.gz"
  sha256 "f6919e4a824ee354f003f0c42e4c4cef98a93aa7e3aa449caedd13f9a2db5530"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffe690a87522627dc0088c391f7237fc6a3f2aa12fc5a3487c0aa6694905dc4d" => :el_capitan
    sha256 "ef5644e4e96604f6f3bbe802e7824a7fd82e01163d532d0e2be6a93cc6595eab" => :yosemite
    sha256 "fe4f9ddeaa505e9b8554f1118a0298fecf8008c2e4d4569675b349e51feba00b" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/hexcurse", "-help"
  end
end
