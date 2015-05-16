class Botan < Formula
  homepage "http://botan.randombit.net/"
  url "http://botan.randombit.net/releases/Botan-1.10.9.tgz"
  sha1 "e1c8e97b214b23931f7dc8aba44306fbeca9055c"

  bottle do
    sha1 "3f9096cdf4156db3af972765fe9b8bb58a7b7261" => :yosemite
    sha1 "d2f2f165eccbd6db984b83149a1f1df1b66dadbb" => :mavericks
    sha1 "26196739a9584d6b3a129e32d3a2358484d6d8ed" => :mountain_lion
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --docdir=#{share}/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    assert_match /lcrypto/, shell_output("#{bin}/botan-config-1.10 --libs")
  end
end

__END__
--- a/src/build-data/makefile/unix_shr.in
+++ b/src/build-data/makefile/unix_shr.in
@@ -57,8 +57,8 @@
 LIBNAME       = %{lib_prefix}libbotan
 STATIC_LIB    = $(LIBNAME)-$(SERIES).a

-SONAME        = $(LIBNAME)-$(SERIES).%{so_suffix}.%{so_abi_rev}
-SHARED_LIB    = $(SONAME).%{version_patch}
+SONAME        = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{so_suffix}
+SHARED_LIB    = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{version_patch}.%{so_suffix}

 SYMLINK       = $(LIBNAME)-$(SERIES).%{so_suffix}
