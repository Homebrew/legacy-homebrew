require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.32.2.tar.gz'
  sha256 'f69e3e08c7be0aa8ac5665f01752eae35ce44ae8daa967be10bc73c0e3205a4d'

  depends_on 'pkg-config' => :build

  keg_only :provided_pre_mountain_lion

  option :universal

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def install
    ENV.universal_binary if build.universal?

    # Disable gtk as it is only used to build tests
    args = %W[--disable-dependency-tracking
              --disable-gtk
              --prefix=#{prefix}]

    args << "--disable-mmx" if ENV.compiler == :clang

    system "./configure", *args
    system "make install"
  end
end
