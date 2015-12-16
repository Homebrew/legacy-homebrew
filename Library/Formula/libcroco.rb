class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.10.tar.xz"
  sha256 "72066611df77f5c4fb28268cfc7306ecc1517212a6182c2ea756c326a154246c"

  bottle do
    cellar :any
    sha256 "fd0eadca9804cfbfd338b95b365d28080a80a7ed3bf3421595fdb0717cf80131" => :el_capitan
    sha256 "a3f6a8e4d231a33ff0081cc7e967510e9805c61b9e4717fa144add6e2640b672" => :yosemite
    sha256 "8b9ea38c7c54700e5148dea73a2ae118b473083a01bcaa2a19ab2ef98a8184e2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"

  def install
    ENV.libxml2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
