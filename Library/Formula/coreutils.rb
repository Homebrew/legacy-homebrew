require 'formula'

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.21.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.21.tar.xz'
  sha256 'adaa44bdab3fa5eb352e80d8a31fdbf957b78653d0c2cd30d63e161444288e18'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--without-gmp"
    system "make install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/'gnubin').install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/'gnuman'/'man1').install_symlink man1/"g#{cmd}" => cmd
    end
    # Symlink all commands that do not conflict with existing OSX or builtins
    coreutils_non_conflicting_filenames.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'. Additionally, commands
    which do not conflict with shell builtins or OSX commands have been linked
    with their standard names, e.g. "dircolors".

    If you really need to use all commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_prefix}/libexec/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_prefix}/libexec/gnuman:$MANPATH"

    EOS
  end

  def coreutils_filenames (dir)
    filenames = []
    dir.find do |path|
      next if path.directory? or path.basename.to_s == '.DS_Store'
      filenames << path.basename.to_s.sub(/^g/,'')
    end
    filenames.sort
  end

  def coreutils_non_conflicting_filenames
    %w[chcon dir dircolors factor hostid nproc numfmt pinky pix ptx realpath runcon
       sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf tac timeout truncate
       vdir]
  end
end
