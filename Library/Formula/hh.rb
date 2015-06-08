class Hh < Formula
  desc "Bash history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.16/hh-1.16-src.tgz"
  sha1 "43c353662a0b31aa56d683fa6ff519bded289c51"

  bottle do
    cellar :any
    sha256 "ac98ac6b688292e6a10cf15fad9b7010dae97af3de8ead3b2c518aa8c6b74063" => :yosemite
    sha256 "cf97b8be45310c6c43f43c3c7f1d35b97ef9811bc20a5eb46d8a36e2d6823832" => :mavericks
    sha256 "947d41c44564edc123d5cefc16eadd4d9e54bcf9a8e07beb78f2807344b76c67" => :mountain_lion
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
