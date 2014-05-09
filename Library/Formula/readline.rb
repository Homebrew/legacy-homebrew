require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz'
  sha256 '56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43'
  version '6.3.5'

  bottle do
    cellar :any
    sha1 "f18f34972c5164ea4cb94b3311e52fc04ea4b9a9" => :mavericks
    sha1 "131d59e8bb99e5a9d0270a04e63c07d794750695" => :mountain_lion
    sha1 "b119b5a05f21f9818b6c99e173597fba62d89b58" => :lion
  end

  keg_only <<-EOS
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
    url "https://gist.githubusercontent.com/jacknagel/8df5735ae9273bf5ebb2/raw/827805aa2927211e7c3d9bb871e75843da686671/readline.diff"
    sha1 "2d55658a2f01fa14a029b16fea29d20ce7d03b78"
  end

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--enable-multibyte"
    system "make install"

    # The 6.3 release notes say:
    #   When creating shared libraries on Mac OS X, the pathname written into the
    #   library (install_name) no longer includes the minor version number.
    # Software will link against libreadline.6.dylib instead of libreadline.6.3.dylib.
    # Therefore we create symlinks to avoid bumping the revisions on dependents.
    # This should be removed at 6.4.
    lib.install_symlink "libhistory.6.3.dylib" => "libhistory.6.2.dylib",
                        "libreadline.6.3.dylib" => "libreadline.6.2.dylib"
  end
end
