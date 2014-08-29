require 'formula'

class MitScheme < Formula
  homepage 'http://www.gnu.org/software/mit-scheme/'
  url 'http://ftpmirror.gnu.org/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz'
  sha1 'd2820ee76da109d370535fec6e19910a673aa7ee'

  bottle do
    sha1 "dadd99b6228b6950c91e57a0e5197a5f61f80cd1" => :mavericks
    sha1 "d91e6fdd907d7747fa56cced88926242888d50d5" => :mountain_lion
    sha1 "e02e2cf5cc62c24159ef5690172c9bcb4e09645d" => :lion
  end

  conflicts_with 'tinyscheme', :because => 'both install a `scheme` binary'

  depends_on :x11

  def install
    # The build breaks __HORRIBLY__ with parallel make -- one target will erase something
    # before another target gets it, so it's easier to change the environment than to
    # change_make_var, because there are Makefiles littered everywhere
    ENV.j1


    # Liarc builds must launch within the src dir, not using the top-level Makefile
    cd "src"

    # Take care of some hard-coded paths
    inreplace %w(6001/edextra.scm 6001/floppy.scm compiler/etc/disload.scm microcode/configure
    edwin/techinfo.scm edwin/unix.scm lib/include/configure lib/include/option.h
    swat/c/tk3.2-custom/Makefile swat/c/tk3.2-custom/tcl/Makefile swat/scheme/other/btest.scm) do |s|
      s.gsub! "/usr/local", prefix
    end

    # The configure script will add '-isysroot' to CPPFLAGS, so it didn't check .h here
    # by default even Homebrew is installed in /usr/local. This breaks things when gdbm
    # or other optional dependencies was installed using Homebrew
    ENV.prepend 'CPPFLAGS', "-I#{HOMEBREW_PREFIX}/include"
    ENV['MACOSX_SYSROOT'] = MacOS.sdk_path
    system "etc/make-liarc.sh", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
