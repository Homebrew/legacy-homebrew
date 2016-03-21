class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://mirrorservice.org/sites/sources.redhat.com/pub/libffi/libffi-3.2.tar.gz"
  mirror "ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz"
  sha256 "6b2680fbf6ae9c2381d381248705857de22e05bae191889298f8e6bfb2ded4ef"

  bottle do
    cellar :any
  end

  head do
    url "https://github.com/atgreen/libffi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx," but some formulae require this version of libffi."

  def install
    ENV.deparallelize # https://github.com/Homebrew/homebrew/pull/19267
    system "./autogen.sh" if build.head?
    system "python", "./generate-darwin-source-and-headers.py", "--only-osx"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    if Hardware::CPU.intel?
      if OS::Mac.prefer_64_bit?
        cd("build_macosx-x86_64"){system "make"}
        system "make", "install"
      else
        cd("build_macosx-i386"){system "make"}
       system "make", " install"
      end
    else
      system "make"
      system "make", "install"
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
