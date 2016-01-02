class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "http://cgdb.me/files/cgdb-0.6.8.tar.gz"
  sha256 "be203e29be295097439ab67efe3dc8261f742c55ff3647718d67d52891f4cf41"

  bottle do
    sha256 "8d47a315bc04053f84802069723edf9ea920c7361464992c1a657f41db52f901" => :el_capitan
    sha256 "b105849b8556fbe4badea662619525b3c0d5d3fd46738e3c7257e6250c7107dd" => :yosemite
    sha256 "87938fedfd548c40fd567e07e0e277f71a5ca69218e741975bcbeb104a4108d8" => :mavericks
    sha256 "218acd2aa10e805643898b5b04da0022b9b1e7186519493c80b26a14e13203ba" => :mountain_lion
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
