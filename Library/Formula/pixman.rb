require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.26.0.tar.gz'
  sha1 '6f45d76ce8ef4aa570d0f9cbcc1b8bcecc863ab7'

  depends_on 'pkg-config' => :build
  depends_on :x11

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
              --prefix=#{prefix}
    ]

    if ENV.compiler == :clang
      args << "--disable-mmx"
    end

    # Disable gtk as it is only used to build tests
    system "./configure", *args
    system "make install"
  end
end
