class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "http://botan.randombit.net/"

  stable do
    url "http://botan.randombit.net/releases/Botan-1.10.10.tgz"
    sha256 "6b67b14746410461fe4a8ce6a625e7eef789243454fe30eab7329d5984be4163"
    # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
    patch :DATA
  end

  bottle do
    cellar :any
    revision 1
    sha256 "3d9ac88803bf21b0b05873d7ed3a9bec621f2d3f2a173df627c9f1cf9ea1c34c" => :el_capitan
    sha256 "7773f8464a8a9f07f3f8f0e7038a0ef9d5b991d96d5664db950f3c3f6f307c3b" => :yosemite
    sha256 "635c7292d3c14242563d0cb6cd585a5de91fb0b23af8737121d9131778740c0e" => :mavericks
  end

  devel do
    url "http://botan.randombit.net/releases/Botan-1.11.23.tgz"
    sha256 "04b02b54419d5ec9c97363123abd41b6f5537d20e9f9932068c362c807bc8f08"
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11 if build.devel?

  def install
    ENV.cxx11 if build.devel?

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
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
    # stable version doesn't have `botan` executable
    if !File.exist? bin/"botan"
      assert_match "lcrypto", shell_output("#{bin}/botan-config-1.10 --libs")
    else
      system bin/"botan", "keygen"
      File.exist? "public.pem"
      File.exist? "private.pem"
    end
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
