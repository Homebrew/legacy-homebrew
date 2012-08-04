require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.26.2.tar.gz'
  sha1 '3c7d72b5b52e6d301efc68aa480f0737a641bdd3'

  depends_on 'pkg-config' => :build
  depends_on :x11

  keg_only :provided_by_osx, <<-EOS.undent
    Apple provides an outdated version of libpixman in its X11 distribution.
    A more up-to-date version is available in XQuartz.
    EOS

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    args = %W[--disable-dependency-tracking
              --disable-gtk
              --prefix=#{prefix}]

    args << "--disable-mmx" if ENV.compiler == :clang

    # Disable gtk as it is only used to build tests
    system "./configure", *args
    system "make install"
  end
end
