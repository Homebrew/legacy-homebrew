class Yap < Formula
  desc "Prolog compiler designed for performance and extensibility"
  homepage "https://www.dcc.fc.up.pt/~vsc/Yap/"
  url "https://www.dcc.fc.up.pt/~vsc/Yap/yap-6.2.2.tar.gz"
  sha256 "f15f8382104443319a5883eafce5f52f4143b526c7f1cd88d19c1f63fc06d750"
  revision 1

  devel do
    url "https://www.dcc.fc.up.pt/~vsc/Yap/yap-6.3.3.tar.gz"
    sha256 "aee3b449b1669af07a8291ce6e7fb0a9b35e1343e2ab96fadb1a37552397fa78"
  end

  bottle :disable, "Fails with various compilers"

  depends_on "gmp"
  depends_on "readline"

  fails_with :gcc => "5"

  fails_with :clang do
    cause "uses variable-length arrays in structs, which will never be supported by clang"
  end

  def install
    system "./configure", "--enable-tabling",
                          "--enable-depth-limit",
                          "--enable-coroutining",
                          "--enable-threads",
                          "--enable-pthread-locking",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-java=/Library/Java/Home",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/yap", "-dump-runtime-variables"
  end
end
