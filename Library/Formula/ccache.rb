require 'formula'

class Ccache < Formula
  homepage 'http://ccache.samba.org/'
  url 'http://samba.org/ftp/ccache/ccache-3.1.10.tar.bz2'
  sha1 'f78154d526b98546c27e5ef480354f3ce021abe2'

  bottle do
    cellar :any
    sha1 "5679d6b03cb483ea5a410b64683879351b417bd5" => :yosemite
    sha1 "a8ea6388d840a5010cc1335aac6a16f937618446" => :mavericks
    sha1 "5562df8168b3cc70cf8ca74c70c2baa2df5be6a6" => :mountain_lion
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
