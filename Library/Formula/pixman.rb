require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.28.2.tar.gz'
  sha256 '2afac9006adbc3fba28830007d7a9521b118d516342478dfe7818ffe4aeb9b55'

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
