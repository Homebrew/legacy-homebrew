class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.samba.org/"
  url "https://samba.org/ftp/ccache/ccache-3.2.3.tar.bz2"
  sha256 "b07165d4949d107d17f2f84b90b52953617bf1abbf249d5cc20636f43337c98c"

  bottle do
    sha256 "2ca210da714761dd4651ac84f5c8dbdb0caa62ac667526e2fcb0c39629a6569b" => :el_capitan
    sha256 "0d2060ebd35b964a44fefbf728d5d40df0993d6b2ccd970a737aff37db7b6299" => :yosemite
    sha256 "8de05f470558cc803f0f536c915b9f2a5b8ef47dc34709929d4c9a6f2e646630" => :mavericks
    sha256 "215a131c1f10a74a5575ea5f5f9285a51929d62da6c5313a3e7ad0e30068d7e7" => :mountain_lion
  end

  head do
    url "https://github.com/jrosdahl/ccache.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-bundled-zlib"
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
