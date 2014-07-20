require 'formula'

class Libffi < Formula
  homepage 'http://sourceware.org/libffi/'
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.13.tar.gz'
  mirror 'ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz'
  sha1 'f5230890dc0be42fb5c58fbf793da253155de106'

  bottle do
    cellar :any
    sha1 "b6a9696c2a58f34f37cf2bca5a652ee6982c3c14" => :mavericks
    sha1 "421a0108078e79a1e32ccebea8eeadce0d0533db" => :mountain_lion
    sha1 "c2ad5c7f63e06566494d92baa1e31c0c2190ea05" => :lion
  end

  head do
    url 'https://github.com/atgreen/libffi.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of libffi."

  def install
    ENV.deparallelize # https://github.com/Homebrew/homebrew/pull/19267
    ENV.universal_binary
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/'closure.c').write <<-TEST_SCRIPT.undent
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
