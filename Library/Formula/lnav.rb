class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.0/lnav-0.8.0.tar.gz"
  sha256 "fbebe3f4656c89b307fe06e7746e6146ae856048413a7cd98aaf8fc2bb34fc33"

  bottle do
    sha256 "e9517c62ec980ae5cf4e23927806f6d701b70feb2d8097dedbbc9c35eb91c572" => :el_capitan
    sha256 "e58d5a2f1ca5db2282969a230b8896ca18092d627bb35078f3e53ab6c8690284" => :yosemite
    sha256 "28f135c1ca5201566eec2e75a9c724fc77af0b1c7d12a821438246b14db4e840" => :mavericks
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "curl" => ["with-libssh2", :optional]

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
