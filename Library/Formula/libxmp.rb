class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.8/libxmp-4.3.8.tar.gz"
  sha256 "de9a25b5f28e5f82010ade423bb63adc6ad235c2aeca4b7433ec5d0a43020640"

  bottle do
    cellar :any
    sha256 "03e06b3182491c292cee3efc6b1b5718d1874c5233f4ccf9c4ebc4cdb2fdf9a6" => :yosemite
    sha256 "208465d33f34a909397aabbe88139e952bebfeda428f1c79819dfb50f5832dde" => :mavericks
    sha256 "615b556b2c0cb26f624c483db529a29add9cfe44ec168a562d90705a09af9d7d" => :mountain_lion
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: http://web.archive.org/web/20120215215707/http://www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    (share/"libxmp").install resource("demo_mods")
  end

  test do
    test_mod = share/"libxmp/give-me-an-om.mod"
    (testpath/"libxmp_test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "xmp.h"

      int main(int argc, char** argv)
      {
          char* mod = argv[1];
          xmp_context context;
          struct xmp_module_info mi;

          context = xmp_create_context();
          if (xmp_load_module(context, mod) != 0) {
              puts("libxmp failed to open module!");
              return 1;
          }

          xmp_get_module_info(context, &mi);
          puts(mi.mod->name);
          return 0;
      }
    EOS

    system ENV.cc, "libxmp_test.c", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("\"#{testpath}/libxmp_test\" #{test_mod}").chomp
  end
end
