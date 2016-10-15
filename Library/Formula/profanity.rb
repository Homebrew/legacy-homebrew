require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im"
  url "https://github.com/boothj5/profanity.git", :tag => "0.3.0"
  #sha1 "ea5fdaa50a05f78a99f3924dd5638129d80f8a6a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl" => :build
  depends_on "curl" => :build
  depends_on "glib" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "libstrophe"

  def install
    #generate_version
    inreplace "configure.ac", "AC_CHECK_LIB([ncursesw], [main], [],", "AC_CHECK_LIB([ncurses], [main], [],"
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won"t accept that! It"s enough to just replace
    # "false" with the main program this formula installs, but it"d be nice if you
    # were more thorough. Run the test with `brew test profanity`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "#{bin}/profanity", "--version"
  end
end
