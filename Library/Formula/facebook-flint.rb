class FacebookFlint < Formula
  desc "Flint - An open-source lint program for C++ developed by, and used at Facebook."
  homepage "https://github.com/facebook/flint"
  url "https://github.com/facebook/flint.git"
  sha256 ""
  version "1.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dmd" => :build
  depends_on "folly" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  
  def install
    ENV.deparallelize

    # remove C++ parts (wait for https://github.com/facebook/flint/pull/31)
    system "gsed -i 's/SUBDIRS = . cxx//' Makefile.am"
    system "gsed -i 's@cxx/Makefile@@' configure.ac"
    
    system "autoreconf -iv"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
  
  test do
    (testpath/"test.h").write("class C { C(int a); C(const C&&); };")
    system "#{bin}/flint test.h 2>&1 | grep \"Missing include guard\""
  end
end
