class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "http://www.unicorn-engine.org"
  url "https://github.com/unicorn-engine/unicorn/archive/0.9.tar.gz"
  sha256 "1ca03b1c8f6360335567b528210713461e839d47c4eb7c676ba3aa4f72b8cf10"
  head "https://github.com/unicorn-engine/unicorn.git"

  bottle do
    cellar :any
    sha256 "760cd9e01aef293fa1046ba71e608fc66c9689759061d5aef8f6a9f45e69a5cb" => :el_capitan
    sha256 "c908ef47188f1a21412e6dd808aab7f7d234e7374b37393d4601efbfd7ded8fb" => :yosemite
    sha256 "8f5ff05290b73e5ceee5af78ea8f46a7167a64e71282f1c5917bbf2612d7e8ee" => :mavericks
  end

  option "with-all", "Build with support for ARM64, Motorola 64k, PowerPC and "\
    "SPARC"
  option "with-debug", "Create a debug build"

  depends_on "glib"
  depends_on "pkg-config" => :build

  def install
    archs  = %w[x86 x86_64 arm mips]
    archs += %w[aarch64 m64k ppc sparc] if build.with?("all")
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = archs.join " "
    ENV["UNICORN_SHARED"] = "yes"
    if build.with?("debug")
      ENV["UNICORN_DEBUG"] = "yes"
    else
      ENV["UNICORN_DEBUG"] = "no"
    end
    system "make", "install"
  end

  test do
    (testpath/"test1.c").write <<-EOS
      /* Adapted from http://www.unicorn-engine.org/docs/tutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder
       * assertion that the libraries are intact and available.
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
        if (err != UC_ERR_OK) {
          fprintf(stderr, "Failed on uc_open() with error %u.\\n", err);
          return -1;
        }
        uc_mem_map(uc, ADDRESS, 2 * 1024 * 1024, UC_PROT_ALL);
        if (uc_mem_write(uc, ADDRESS, X86_CODE32, sizeof(X86_CODE32) - 1)) {
          fputs("Failed to write emulation code to memory.\\n", stderr);
          return -1;
        }
        uc_reg_write(uc, UC_X86_REG_ECX, &r_ecx);
        uc_reg_write(uc, UC_X86_REG_EDX, &r_edx);
        err = uc_emu_start(uc, ADDRESS, ADDRESS + sizeof(X86_CODE32) - 1, 0, 0);
        if (err) {
          fprintf(stderr, "Failed on uc_emu_start with error %u (%s).\\n",
            err, uc_strerror(err));
          return -1;
        }
        uc_close(uc);
        puts("Emulation complete.");
        return 0;
      }
    EOS
    system ENV.cc, "-o", testpath/"test1", testpath/"test1.c", "-lglib-2.0",
      "-lpthread", "-lm", "-lunicorn"
    system testpath/"test1"
  end
end
