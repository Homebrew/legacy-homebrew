class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://mirrorservice.org/sites/sources.redhat.com/pub/libffi/libffi-3.2.1.tar.gz"
  mirror "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
  sha256 "d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37"

  bottle do
    cellar :any
  end

  head do
    url "https://github.com/atgreen/libffi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx," Some formulae require this version of libffi."

  stable do
    patch :DATA
  end

  def install
    ENV.deparallelize # https://github.com/Homebrew/homebrew/pull/19267
    system "./autogen.sh" if build.head?
    system "python", "./generate-darwin-source-and-headers.py", "--only-osx"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    if build.universal?
      cd("build_macosx-x86_64"){system "make"}
      cd("build_macosx-i386"){system "make"}
      system "lipo", "-create", "build_macosx-x86_64/.libs/libffi.6.dylib", "build_macosx-i386/.libs/libffi.6.dylib", "-output", "libffi.6.dylib"
      system "lipo", "-create", "build_macosx-x86_64/.libs/libffi.a", "build_macosx-i386/.libs/libffi.a", "-output", "libffi.a"
      lib.install "libffi.6.dylib"
      lib.install "libffi.a"
    else
      if Hardware::CPU.intel?
        if OS::Mac.prefer_64_bit?
          cd("build_macosx-x86_64"){system "make";lib.install ".libs/libffi.6.dylib";lib.install ".libs/libffi.a"}
         else
          cd("build_macosx-i386"){system "make";lib.install ".libs/libffi.6.dylib";lib.install ".libs/libffi.a"}
        end
      end
    end
  end

  test do
    (testpath/"closure.c").write <<-TEST_SCRIPT.undent
     #include <stdio.h>
     #include <ffi.h>

     /* Acts like puts with the file given at time of enclosure. */
     void puts_binding(ffi_cif *cif, unsigned int *ret, void* args[],
                       FILE *stream)
     {
       *ret = fputs(*(char **)args[0], stream);
     }

     int main()
     {
       ffi_cif cif;
       ffi_type *args[1];
       ffi_closure *closure;

       int (*bound_puts)(char *);
       int rc;

       /* Allocate closure and bound_puts */
       closure = ffi_closure_alloc(sizeof(ffi_closure), &bound_puts);

       if (closure)
         {
           /* Initialize the argument info vectors */
           args[0] = &ffi_type_pointer;

           /* Initialize the cif */
           if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 1,
                            &ffi_type_uint, args) == FFI_OK)
             {
               /* Initialize the closure, setting stream to stdout */
               if (ffi_prep_closure_loc(closure, &cif, puts_binding,
                                        stdout, bound_puts) == FFI_OK)
                 {
                   rc = bound_puts("Hello World!");
                   /* rc now holds the result of the call to fputs */
                 }
             }
         }

       /* Deallocate both closure, and bound_puts */
       ffi_closure_free(closure);

       return 0;
     }
    TEST_SCRIPT

    flags = ["-L#{lib}", "-lffi", "-I#{lib}/libffi-#{version}/include"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
__END__
--- ./Makefile.am.org	2016-03-22 14:58:33.000000000 +0900
+++ ./Makefile.am	2016-03-22 14:59:26.000000000 +0900
@@ -140,7 +140,7 @@ endif
 if X86_DARWIN
 nodist_libffi_la_SOURCES += src/x86/ffi.c src/x86/darwin.S src/x86/ffi64.c src/x86/darwin64.S
 if X86_DARWIN32
-nodist_libffi_la_SOURCES += src/x86/win32.S
+nodist_libffi_la_SOURCES += src/x86/darwin.S
 endif
 endif
 if SPARC
