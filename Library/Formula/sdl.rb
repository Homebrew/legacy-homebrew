require 'formula'

class Sdl < Formula
  homepage 'http://www.libsdl.org/'
  url 'http://www.libsdl.org/release/SDL-1.2.15.tar.gz'
  sha1 '0c5f193ced810b0d7ce3ab06d808cbb5eef03a2c'

  bottle do
    cellar :any
    revision 1
    sha1 "349711f92cec0b02b53439b3126fe540bfea04e1" => :yosemite
    sha1 "77ec0e596a9a66c60f843a2528b38d2ef2e4c9f5" => :mavericks
    sha1 "d27291ac68ac7c22e6c7b35d0e658a65a6f2d189" => :mountain_lion
  end

  head do
    url 'http://hg.libsdl.org/SDL', :branch => 'SDL-1.2', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option 'with-x11-driver', 'Compile with support for X11 video driver'
  option :universal

  if build.with? 'x11-driver'
    depends_on :x11
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix build against recent libX11; requires regenerating configure script
    patch do
      url "http://hg.libsdl.org/SDL/raw-rev/91ad7b43317a"
      sha1 "1b35949d9ac360a7e39aac76d1f0a6ad5381b0f4"
    end
  end

  # Fix for a bug preventing SDL from building at all on OSX 10.9 Mavericks
  # Related ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
  patch do
    url "http://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320"
    sha1 "3137feb503a89a8d606405373905b92dcf7e293b"
  end

  # Fix compilation error on 10.6 introduced by the above patch
  patch do
    url "http://bugzilla-attachments.libsdl.org/attachment.cgi?id=1324"
    sha1 "08c19f077f56217fd300db390bca4c1a0bee0622"
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl.pc.in sdl-config.in], '@prefix@', HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head? or build.with? 'x11-driver'

    args = %W[--prefix=#{prefix}]
    args << "--disable-nasm" unless MacOS.version >= :mountain_lion # might work with earlier, might only work with new clang
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or (ENV.compiler == :clang and MacOS.clang_build_version < 421)
    args << "--without-x" if build.without? 'x11-driver'

    system './configure', *args
    system "make install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"] unless build.head?
  end

  test do
    system "#{bin}/sdl-config", "--version"
  end
end
