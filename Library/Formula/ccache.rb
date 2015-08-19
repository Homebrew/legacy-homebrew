class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.samba.org/"
  url "https://samba.org/ftp/ccache/ccache-3.2.2.tar.bz2"
  sha256 "440f5e15141cc72d2bfff467c977020979810eb800882e3437ad1a7153cce7b2"

  bottle do
    sha256 "56dbbc62a9951890abc7d1ddaf52e615127c9464365f771929f8490aa5355c05" => :yosemite
    sha256 "d227f6264bc437b518a3b3be71e5d2320eac6afb9c231bca980d6e582f379943" => :mavericks
    sha256 "8c1b912920988e7429679ca9e2aca9e4ee7ebfaa28b990b9b8afdffb1e028d7d" => :mountain_lion
  end

  head do
    url "https://github.com/jrosdahl/ccache.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9 gcc-5
      c++ c++3 c++-3.3 c++-4.0 c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9 c++-5
      g++ g++2 g++3 g++-3.3 g++-4.0 g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9 g++-5
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

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    system "#{bin}/ccache", "-s"
  end
end
