class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.3.tar.gz"
  sha256 "a5a69a6abf80bcce713fa873607735fe712f44276a7f048d60a61bb2f6b3c90c"

  bottle do
    cellar :any
    revision 1
    sha1 "8254a12777c10ec1d4f1d896a07d03d62fdc5c99" => :yosemite
    sha1 "0e9a2ac818e67dfb759ce8d43f4abd3a0dcaed8b" => :mavericks
    sha1 "3211cd71e5c956e38ed934c65be376a42aaf63c9" => :mountain_lion
  end

  head do
    url "http://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix}]
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << "--disable-assembly" if ENV.compiler == :llvm || (ENV.compiler == :clang && MacOS.clang_build_version < 421)
    args << "--without-x"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sdl2-config", "--version"
  end
end
