require 'formula'

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.17.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.17.tar.xz'
  sha256 '4e075a0d238072a5bd079046e1f024dc5e0d9133d43a39c73d0b86b0d1e2c5e5'

  depends_on 'xz' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make install"

    # set installed binaries
    commands = coreutils_bins

    # create a gnubin dir that has all the commands without program-prefix
    (libexec+'gnubin').mkpath
    commands.each do |cmd|
      ln_sf "../../bin/g#{cmd}", libexec+"gnubin/#{cmd}"
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
    require 'find'
    bin_path = prefix+'bin'
    commands = Array.new
    Find.find(bin_path) do |path|
      next if path == bin_path or File.basename(path) == '.DS_Store'
      commands << File.basename(path).sub(/^g/,'')
    end
    return commands.sort
  end
end
