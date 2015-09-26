class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.9/libxmp-4.3.9.tar.gz"
  sha256 "8acdcc7c4b97558b36279ec26fd03d3c34b4fed20e06a84fa0ce667816c78a95"

  bottle do
    cellar :any
    sha256 "157fc6129d524c09e4a579518ce188232c57289796bd12dbc2336903db96585e" => :yosemite
    sha256 "1deb9f6fbcc61ed06c214689e28dd4eb928e0fc48d7b4f195957127c9a63f30f" => :mavericks
    sha256 "404246eba6c82c4768baef86453a8317fb4ec911619cd74e391332675c62d45e" => :mountain_lion
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
    system "make", "install"

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
