class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "http://ftpmirror.gnu.org/readline/readline-6.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz"
  sha256 "56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43"
  version "6.3.8"

  bottle do
    cellar :any
    sha256 "9d38481c935cef21ead25c294285b78a9e8fa556fd15ede9126926c055c40d37" => :el_capitan
    sha256 "d0cdb3e162c05e21c7184e86629f04685d4be98e38cbf024373142bf8764500e" => :yosemite
    sha256 "adcc6352d3fb271a1e9ce034d80996405a5c46afbd1bab1507d3ff5e89e02bc1" => :mavericks
    sha256 "6b1d7e806e169e2b778371d74e7cc62106c348ea9f5c80fd658b763b94dc748e" => :mountain_lion
    sha256 "c129333634dd00ab2267ae9c531fca1f5cc50dd519ed3399918289fdfdf2663b" => :lion
  end

  keg_only :shadowed_by_osx, <<-EOS.undent
    OS X provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only.
  EOS

  # Vendor the patches.
  # The mirrors are unreliable for getting the patches, and the more patches
  # there are, the more unreliable they get. Pulling this patch inline to
  # reduce bug reports.
  # Upstream patches can be found in:
  # http://git.savannah.gnu.org/cgit/readline.git
  patch do
    url "https://gist.githubusercontent.com/jacknagel/d886531fb6623b60b2af/raw/746fc543e56bc37a26ccf05d2946a45176b0894e/readline-6.3.8.diff"
    sha256 "ef4fd6f24103b8f1d1199a6254d81a0cd63329bd2449ea9b93e66caf76d7ab89"
  end

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--enable-multibyte"
    system "make", "install"

    # The 6.3 release notes say:
    #   When creating shared libraries on Mac OS X, the pathname written into the
    #   library (install_name) no longer includes the minor version number.
    # Software will link against libreadline.6.dylib instead of libreadline.6.3.dylib.
    # Therefore we create symlinks to avoid bumping the revisions on dependents.
    # This should be removed at 6.4.
    lib.install_symlink "libhistory.6.3.dylib" => "libhistory.6.2.dylib",
                        "libreadline.6.3.dylib" => "libreadline.6.2.dylib"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lreadline", "-o", "test"
    assert_equal "Hello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end
