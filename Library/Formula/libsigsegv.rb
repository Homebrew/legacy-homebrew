class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "http://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.10.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz"
  sha256 "8460a4a3dd4954c3d96d7a4f5dd5bc4d9b76f5754196aa245287553b26d2199a"

  bottle do
    cellar :any
    revision 1
    sha1 "a94a8a97acf78584c8cf8dfcb2dfc17f48597c59" => :yosemite
    sha1 "3e7f4bfdaeb16fcf38d82e8423774c4baf0f7efd" => :mavericks
  end

  fails_with :llvm do
    build 2336
    cause "Fails make check with LLVM GCC from XCode 4 on Snow Leopard"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Sourced from tests/efault1.c in tarball.
    (testpath/"test.c").write <<-EOS.undent
      #include "sigsegv.h"

      #include <errno.h>
      #include <fcntl.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>

      const char *null_pointer = NULL;
      static int
      handler (void *fault_address, int serious)
      {
        abort ();
      }

      int
      main ()
      {
        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected alone");
            exit (1);
          }

        if (sigsegv_install_handler (&handler) < 0)
          exit (2);

        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected with handler");
            exit (1);
          }

        printf ("Test passed");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-lsigsegv", "-o", "test"
    assert_match /Test passed/, shell_output("./test")
  end
end
