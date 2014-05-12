require 'formula'

class GnuTar < Formula
  homepage 'http://www.gnu.org/software/tar/'
  url 'http://ftpmirror.gnu.org/tar/tar-1.27.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/tar/tar-1.27.1.tar.gz'
  sha1 '192f480cac95b1fbaff11c87a64f7092045b411b'

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g"

    system "./configure", *args
    system "make install"

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/'gnubin').install_symlink bin/"gtar" => "tar"
  end

  def caveats; <<-EOS.undent
    gnu-tar has been installed as 'gtar'.

    If you really need to use it as 'tar', you can add a 'gnubin' directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end
end
