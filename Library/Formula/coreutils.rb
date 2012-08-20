require 'formula'

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.18.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.18.tar.xz'
  sha256 '11dc114374100ac6f56d4b66f588e51d3fe972855466a35a27de7ec67eb2143f'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_bins.each do |cmd|
      (libexec/'gnubin').install_symlink bin/"g#{cmd}" => cmd
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    EOS
  end

  def coreutils_bins
    commands = []
    bin.find do |path|
      next if path.directory? or path.basename.to_s == '.DS_Store'
      commands << path.basename.to_s.sub(/^g/,'')
    end
    commands.sort
  end
end
