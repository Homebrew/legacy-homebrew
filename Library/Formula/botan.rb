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
    revision 1
    sha256 "21928e32477150b767937ecfbf8be519c279474eb7273c38475ee39501084977" => :yosemite
    sha256 "a89a03f87751e838d0e7265fff8f92f19782048b2b17bd0bcadbcef186f4f29f" => :mavericks
    sha256 "c8899f3e0b379e27e37fd7e3e83bbec52803cce45800c7bf88c509f09a7e520b" => :mountain_lion
  end

  devel do
    url "http://botan.randombit.net/releases/Botan-1.11.19.tgz"
    sha256 "4b0f3be4262bdc71629ea4a38e2ed85ff53e573054ad84ba37d65fc1477b3028"
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
