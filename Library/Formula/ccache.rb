require 'formula'

class Ccache < Formula
  homepage 'http://ccache.samba.org/'
  url 'http://samba.org/ftp/ccache/ccache-3.2.tar.bz2'
  sha1 '2dce973a0dc0208108202983ccb7332c30e3b0fd'

  bottle do
    sha1 "5f2b5557da18bbaf56ddf0082714f4174587f48e" => :yosemite
    sha1 "6fd29412eb8863abfb823dfdc6b14971a447c0ee" => :mavericks
    sha1 "a2f3ed24c30f6402ab646cf55b7a4914af9e0551" => :mountain_lion
  end

  head do
    url 'https://github.com/jrosdahl/ccache.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system './autogen.sh' if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      c++ c++3 c++-3.3 c++-4.0 c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      g++ g++2 g++3 g++-3.3 g++-4.0 g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats; <<-EOS.undent
    To install symlinks for compilers that will automatically use
    ccache, prepend this directory to your PATH:
      #{opt_libexec}

    If this is an upgrade and you have previously added the symlinks to
    your PATH, you may need to modify it to the path specified above so
    it points to the current version.

    NOTE: ccache can prevent some software from compiling.
    ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end
end
