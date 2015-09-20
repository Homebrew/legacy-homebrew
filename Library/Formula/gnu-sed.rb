class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "http://ftpmirror.gnu.org/sed/sed-4.2.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.bz2"
  sha256 "f048d1838da284c8bc9753e4506b85a1e0cc1ea8999d36f6995bcb9460cddbd7"

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "e7123ca64185d9b6e01b122a0f5a10154fd2405b5b34d765360db55beb9bafca" => :el_capitan
    sha256 "a45ed585278029792f71d8882763ee0e1605e3df7bdb06dd02c8f815e2f58c68" => :yosemite
    sha256 "b074edd2ec60b244284cd1545d83fdf48151ee5b9f8e5f0dc6a509b822d0bb37" => :mavericks
    sha256 "bc210361d787b929011afbe96bd5a78c77e35a14d953942cd278d04c640183ae" => :mountain_lion
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
    (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
  end

  def caveats; <<-EOS.undent
    The command has been installed with the prefix "g".
    If you do not want the prefix, install using the "with-default-names" option.

    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

  test do
    system "#{bin}/gsed", "--version"
  end
end
