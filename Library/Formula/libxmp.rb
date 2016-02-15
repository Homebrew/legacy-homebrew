class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.10/libxmp-4.3.10.tar.gz"
  sha256 "c11c0bf27f3ba97051cd5e3e04d9b487febdc31cb2ce35e462d71fc580eaa5be"

  bottle do
    cellar :any
    sha256 "95a29a2efd115f4bebb9589c0e777f4cee8b0847ebceb4103f11f4f6bfa609d2" => :el_capitan
    sha256 "22ee915a58a14bedf819c307533f1d67d471db3a07a7494ad6b8cfd65b7bd37e" => :yosemite
    sha256 "11fb81b1cf895ef247d38313c0f1385e9d93a3b0d478a2186b83ad19816c8e7f" => :mavericks
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
