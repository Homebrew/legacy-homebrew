require "formula"

class GnuSed < Formula
  homepage "https://www.gnu.org/software/sed/"
  url "http://ftpmirror.gnu.org/sed/sed-4.2.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.bz2"
  sha1 "f17ab6b1a7bcb2ad4ed125ef78948092d070de8f"

  bottle do
    cellar :any
    revision 1
    sha1 "2f92a57761e272e41b00915d3a348927447b249d" => :yosemite
    sha1 "aec8b9fc4ad1c58dc5279ee62133c2a67a24e651" => :mavericks
    sha1 "4dff2a21df4148c95abc04e87544bef1c452951f" => :mountain_lion
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
