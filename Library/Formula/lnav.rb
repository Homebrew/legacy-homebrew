class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.7.3/lnav-0.7.3.tar.gz"
  sha256 "7eb052a8dc60bef6c5f4a8e7135b7089b4413edbf156cc8bafce0557d3166df3"

  bottle do
    sha256 "073daae7ca0ff228f829642a5c780ca339952db2c9d2524e6e92c40091679721" => :yosemite
    sha256 "37bc4dcf53999763eb3cc02943b225553b98a3827271449e80e09d442143fab9" => :mavericks
    sha256 "a8c2815037bbc1db2d4c8caeaff1cc8e87e9e46c7f486adb8ea7cc60be7c5fe2" => :mountain_lion
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
