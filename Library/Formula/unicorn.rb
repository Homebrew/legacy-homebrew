class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "http://www.unicorn-engine.org"
  url "https://github.com/unicorn-engine/unicorn/archive/0.9.tar.gz"
  sha256 "1ca03b1c8f6360335567b528210713461e839d47c4eb7c676ba3aa4f72b8cf10"
  head "https://github.com/unicorn-engine/unicorn.git"

  option "with-debug", "Create a debug build"
  option "without-x86", "Build without x86 support"
  option "without-x86_64", "Build without x86_64 support"
  option "without-static", "Don't build static libraries"
  option "with-all", "Build with complete architectural support"
  option "with-arm", "Build with ARM support"
  option "with-aarch64", "Build with ARM64 support"
  option "with-m68k", "Build with Motorola 68000 support"
  option "with-mips", "Build with MIPS support"
  option "with-ppc", "Build with PowerPC support"
  option "with-shared", "Build with shared library support"
  option "with-sparc", "Build with SPARC support"

  depends_on "capstone"
  depends_on "glib"
  depends_on "pkg-config" => :build
  depends_on "python"

  def install
    archs = []
    ["x86", "x86_64"].each do |arch|
      archs << arch if build.with? arch
    end
    ["arm", "aarch64", "m64k", "mips", "ppc", "sparc"].each do |arch|
      if (build.with? "all") || (build.with? arch)
        archs << arch
      end
    end
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = archs.join " "
    ["static", "shared", "debug"].each do |condition|
      ENV["UNICORN_#{condition.upcase}"] = build.with?(condition) ? "yes" : "no"
    end
    system "make", "install"
  end

  test do
    source = "test1.c"
    executable = "test1"
    (testpath/source).write <<-EOS
      /* Adapted from http://www.unicorn-engine.org/docs/tutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder assertion
       * that the libraries are intact and available. Expect it to fail if
       * built without x86 support... :D
       */

      #include <stdio.h>

      #include <unicorn/unicorn.h>

      #define X86_CODE32 "\x41\x4a"
      #define ADDRESS 0x1000000

      int main(int argc, char *argv[]) {
        uc_engine *uc;
        uc_err err;
        int r_ecx = 0x1234;
        int r_edx = 0x7890;

        err = uc_open(UC_ARCH_X86, UC_MODE_32, &uc);
        if (err != UC_ERR_OK)
          return -1;
        uc_mem_map(uc, ADDRESS, 2 * 1024 * 1024, UC_PROT_ALL);
        if (uc_mem_write(uc, ADDRESS, X86_CODE32, sizeof(X86_CODE32) - 1))
          return -1;
        uc_reg_write(uc, UC_X86_REG_ECX, &r_ecx);
        uc_reg_write(uc, UC_X86_REG_EDX, &r_edx);
        err = uc_emu_start(uc, ADDRESS, ADDRESS + sizeof(X86_CODE32) - 1, 0, 0);
        if (err)
          return -1;
        uc_close(uc);
        puts("Emulation complete.");
        return 0;
      }
    EOS
    system "cc", *(`pkg-config --libs glib-2.0`.split), "-o", \
      testpath/executable, testpath/source, "-lpthread", "-lm", "-lunicorn"
    system testpath/executable
  end
end
