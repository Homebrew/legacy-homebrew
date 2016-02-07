class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "http://botan.randombit.net/"

  stable do
    url "http://botan.randombit.net/releases/Botan-1.10.12.tgz"
    sha256 "affc3a79919577943f896e64d3e4a4dcc4970c5bf80cc98c7f3a3144745eac27"
    # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "b7d45a848fead326d2e0a1dfbcacfd3c73bf0ad4b2ab62611cf78912db4053a7" => :el_capitan
    sha256 "8dad1bfd83f841d095102056e3b4b769041b4abcb7bd126528f75259cd24f5ff" => :yosemite
    sha256 "521e1f6578e799f5738c28bfd635cba3f210d777d019a240092bbf912ef83699" => :mavericks
  end

  devel do
    url "http://botan.randombit.net/releases/Botan-1.11.28.tgz"
    sha256 "a414c96f45b2707d4750d299ca03ec3fce5ada62ada1ba5cd012a9ace61f5932"
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
      assert_match /\A-----BEGIN PRIVATE KEY-----/,
       shell_output("#{bin}/botan keygen")
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
