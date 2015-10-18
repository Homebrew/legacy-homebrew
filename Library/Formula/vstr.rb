class Vstr < Formula
  desc "C string library"
  homepage "http://www.and.org/vstr/"
  url "http://www.and.org/vstr/1.0.15/vstr-1.0.15.tar.bz2"
  sha256 "d33bcdd48504ddd21c0d53e4c2ac187ff6f0190d04305e5fe32f685cee6db640"

  bottle do
    cellar :any
    sha256 "0d4176307ea18472c9da9a765bcb033e6256ae361d2e32b758b205a56dd7e38a" => :yosemite
    sha256 "5fc509c660fc38b3484a093ce0894ee2e9c3ea3cccc43222071c4d8139975d8d" => :mavericks
    sha256 "10918d69a40e4516a549dae179e73c390248f4eaa8c75460228d9ba7d330fee9" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      // based on http://www.and.org/vstr/examples/ex_hello_world.c
      #define VSTR_COMPILE_INCLUDE 1
      #include <vstr.h>
      #include <errno.h>
      #include <err.h>
      #include <unistd.h>

      int main(void) {
        Vstr_base *s1 = NULL;

        if (!vstr_init())
          err(EXIT_FAILURE, "init");

        if (!(s1 = vstr_dup_cstr_buf(NULL, "Hello Homebrew\\n")))
          err(EXIT_FAILURE, "Create string");

        while (s1->len)
          if (!vstr_sc_write_fd(s1, 1, s1->len, STDOUT_FILENO, NULL)) {
            if ((errno != EAGAIN) && (errno != EINTR))
              err(EXIT_FAILURE, "write");
          }

        vstr_free_base(s1);
        vstr_exit();
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lvstr", "-o", "test"
    system "./test"
  end
end
