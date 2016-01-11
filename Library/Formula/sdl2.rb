class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.4.tar.gz"
  sha256 "da55e540bf6331824153805d58b590a29c39d2d506c6d02fa409aedeab21174b"

  bottle do
    cellar :any
    sha256 "a1778abde0ab41f40c089f9b4f3aaaee3cc18fb096f2f5e8c20aab98f74a1fe9" => :el_capitan
    sha256 "ea65799d906cc57b6dc56fc631013ec820c8b530c4a8bdd2fb39632a75139d21" => :yosemite
    sha256 "9843054a18ffd4603fc19e98f1f5e80224bbbc79e037c81198c94f57c061d346" => :mavericks
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

    system "./autogen.sh" if build.head? || build.devel?

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
