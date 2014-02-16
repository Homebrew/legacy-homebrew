require 'formula'

class Botan < Formula
  homepage 'http://botan.randombit.net/'
  url 'http://botan.randombit.net/files/Botan-1.10.7.tbz'
  sha1 '2cb502e6d8ef4dfcccd28d0aca33c7e5e551e566'

  option 'enable-debug', 'Enable debug build of Botan'

  # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
  def patches; DATA; end

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
 
