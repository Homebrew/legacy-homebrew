class Dwarfutils < Formula
  desc "lib and utility to dump and produce DWARF debug info in ELF objects"
  homepage "http://www.prevanders.net/dwarf.html"
  url "http://www.prevanders.net/libdwarf-20150507.tar.gz"
  sha256 "29aa8d07db659d7d7af7079854cf42c09bf74d303942159cbfee82d655549870"

  bottle do
    cellar :any
    sha256 "90938e4decc07bb5ae51d9ed43554de01d812e5dafea3bef30b7e34e347caeb2" => :yosemite
    sha256 "599743c3fbc31356bf02a701a7216b2cce71f54f24a6f8210f7ec5756a470fe8" => :mavericks
    sha256 "110451d0c1166720bae4f113b2929822434c422fba07bfbf48e05a1031d1cdef" => :mountain_lion
  end

  depends_on "libelf" => :build

  def install
    system "./configure"
    system "make"

    bin.install "dwarfdump/dwarfdump"
    man1.install "dwarfdump/dwarfdump.1"
    lib.install "libdwarf/libdwarf.a"
    include.install "libdwarf/dwarf.h"
    include.install "libdwarf/libdwarf.h"
  end

  test do
    system "#{bin}/dwarfdump", "-V"

    (testpath/"test.c").write <<-EOS.undent
      #include <dwarf.h>
      #include <libdwarf.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *out = NULL;
        int res = dwarf_get_children_name(0, &out);

        if (res != DW_DLV_OK) {
          printf("Getting name failed\\n");
          return 1;
        }

        if (strcmp(out, "DW_children_no") != 0) {
          printf("Name did not match: %s\\n", out);
          return 1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-I#{include}", "-ldwarf", "test.c", "-o", "test"
    system "./test"
  end
end
