require 'formula'

class GnuSed < Formula
  homepage 'http://www.gnu.org/software/sed/'
  url 'http://ftpmirror.gnu.org/sed/sed-4.2.2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.bz2'
  sha1 'f17ab6b1a7bcb2ad4ed125ef78948092d070de8f'

  bottle do
    cellar :any
    sha1 "4e97d284b3429838d296928a70bb700e38c33453" => :mavericks
    sha1 "11a59857a6a4e87059a8c52aeaabfb3283be2113" => :mountain_lion
    sha1 "a60cef42f2169074f1377fdf59dad5b652216d2c" => :lion
  end

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"

    (libexec/'gnubin').install_symlink bin/"gsed" =>"sed"
    (libexec/'gnuman/man1').install_symlink man1/"gsed.1" => "sed.1"
  end

  def caveats; <<-EOS.undent
    The command has been installed with the prefix 'g'.
    If you do not want the prefix, install using the 'default-names' option.

    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

end
