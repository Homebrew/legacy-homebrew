require 'formula'

# 3.0.12 has a packaging error which causes GTK+, and possibly other
# software, to fail to build; see https://github.com/mxcl/homebrew/issues/18329
class Libffi < Formula
  homepage 'http://sourceware.org/libffi/'
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.11.tar.gz'
  mirror 'ftp://sourceware.org/pub/libffi/libffi-3.0.11.tar.gz'
  sha1 'bff6a6c886f90ad5e30dee0b46676e8e0297d81d'

  keg_only :provided_by_osx, "Some formulae require a newer version of libffi."

  def install
    ENV.universal_binary
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

    ENV['PKG_CONFIG_PATH'] = "#{opt_prefix}/lib/pkgconfig"
    flags = `pkg-config --cflags --libs libffi`.split + ENV.cflags.split
    system ENV.cc, "-o", "closure", "closure.c", *flags
    system "./closure"
  end
end
