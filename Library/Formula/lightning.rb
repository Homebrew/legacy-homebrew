class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "http://ftpmirror.gnu.org/lightning/lightning-2.1.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/lightning/lightning-2.1.0.tar.gz"
  sha256 "1fa3a2421852598b3162d6765645bb3cd0fccb5f0c105d0800c64c8428b749a6"

  bottle do
    cellar :any
    revision 1
    sha256 "3837efd2db95a7634d669f554591a2905262b3cc1c4a16d607e970ff4e2ed8c3" => :yosemite
    sha256 "45d0d23a2129e23e0892c6bc8128c48f7641ebdb03c5a13c483c27f6611b8c93" => :mavericks
    sha256 "632b74383622ca9622e1c9a905e94a12f395a2561cb6a5c66dddc072e866a711" => :mountain_lion
  end

  depends_on "binutils" => [:build, :optional]

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    ]
    args << "--disable-disassembler" if build.without? "binutils"

    system "./configure", *args
    system "make", "check", "-j1"
    system "make", "install"
  end

  test do
    # from http://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <lightning.h>
      static jit_state_t *_jit;
      typedef int (*pifi)(int);
      int main(int argc, char *argv[]) {
        jit_node_t  *in;
        pifi incr;
        init_jit(argv[0]);
        _jit = jit_new_state();
        jit_prolog();
        in = jit_arg();
        jit_getarg(JIT_R0, in);
        jit_addi(JIT_R0, JIT_R0, 1);
        jit_retr(JIT_R0);
        incr = jit_emit();
        jit_clear_state();
        printf("%d + 1 = %d\\n", 5, incr(5));
        jit_destroy_state();
        finish_jit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
