require "formula"

class Botan < Formula
  homepage "http://botan.randombit.net/"
  url "http://files.randombit.net/botan/Botan-1.10.8.tgz"
  sha1 "078fcb03c9ef0691621eda3ca312ebf08b3890cc"
  revision 1

  bottle do
    sha1 "89d491598019e57540e22089c3c7a3d45a845adc" => :yosemite
    sha1 "aa5b7be38ab12c1755f3cb8dbee104d9514f27b2" => :mavericks
    sha1 "2efea61b9f63b8344617a90eb4dc0445baab0243" => :mountain_lion
  end

  option "enable-debug", "Enable debug build of Botan"

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

    args << "--enable-debug" if build.include? "enable-debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
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
