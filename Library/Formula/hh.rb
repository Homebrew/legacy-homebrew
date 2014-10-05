require "formula"

class Hh < Formula
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.13/hh-1.13-src.tgz"
  sha1 "09fee6d687a8b8a7c6f508ced071fb88b0a9bb28"

  head do
    url "https://github.com/dvorka/hstr.git"
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on "readline"

  def install
    # Upstream bug report for curses/ncursesw:
    # https://github.com/dvorka/hstr/issues/103
    if build.head?
      inreplace %w(src/hstr.c src/include/hstr_curses.h), "ncursesw/", ""
      system "autoreconf", "-fvi"
    end
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
