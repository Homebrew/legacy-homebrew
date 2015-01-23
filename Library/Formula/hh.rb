class Hh < Formula
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.15/hh-1.15-src.tgz"
  sha1 "c97d27687512d1e26828062df300d56159dfa05b"

  bottle do
    cellar :any
    sha1 "3110fabac2e10d0bd49f0893a9bff1babf8ad4d3" => :yosemite
    sha1 "9e7f8e5fab6fdfb0151eb426a97187e7abeb8519" => :mavericks
    sha1 "e31eebb154535a7fc7e35a498178e1163068e4fb" => :mountain_lion
  end

  head do
    url "https://github.com/dvorka/hstr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline"

  def install
    system "autoreconf", "-fvi" if build.head?
    # Upstream bug report for curses/ncursesw:
    # https://github.com/dvorka/hstr/issues/103
    inreplace %w[src/hstr.c src/include/hstr_curses.h], "ncursesw/", ""
    inreplace "configure", "ncursesw", "ncurses"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/".hh_test"
    path.write "test\n"
    ENV["HISTFILE"] = path
    assert_equal "test\n", `#{bin}/hh -n`
  end
end
