class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "http://cgdb.me/files/cgdb-0.6.8.tar.gz"
  sha256 "be203e29be295097439ab67efe3dc8261f742c55ff3647718d67d52891f4cf41"

  bottle do
    sha256 "8d47a315bc04053f84802069723edf9ea920c7361464992c1a657f41db52f901" => :el_capitan
    sha1 "ad041a0d959f9c78acbaf9e702028418f4fbaced" => :yosemite
    sha1 "49b22ef93ad50cc3189eab87c887aac4bf7d5be6" => :mavericks
    sha1 "4401a042175f6071740d1d87bb5993ebb3b76d2a" => :mountain_lion
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
