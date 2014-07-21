require "formula"

class Coreutils < Formula
  homepage "https://www.gnu.org/software/coreutils"
  url "http://ftpmirror.gnu.org/coreutils/coreutils-8.23.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.23.tar.xz"
  sha256 "ec43ca5bcfc62242accb46b7f121f6b684ee21ecd7d075059bf650ff9e37b82d"

  bottle do
    sha1 "20ea5c8d4b4bafdcd70999129257e5a5b1c30f98" => :mavericks
    sha1 "d4ecd35db414eefdb160eadd76da270319ad91af" => :mountain_lion
    sha1 "63a5af5c94f1b0c4f3331f979aca98bbfde27445" => :lion
  end

  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--without-gmp"
    system "make install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

  def coreutils_filenames (dir)
    filenames = []
    dir.find do |path|
      next if path.directory? or path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/,"")
    end
    filenames.sort
  end
end
