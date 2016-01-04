class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.4.tar.gz"
  sha256 "da55e540bf6331824153805d58b590a29c39d2d506c6d02fa409aedeab21174b"

  bottle do
    cellar :any
    revision 2
    sha256 "8e6efe3ab41d7ef76f37357f56016b717643f0f079e60664f27e77182041ac6c" => :el_capitan
    sha256 "0c54061dec0b6771f6f10058becf7e0cf247d0523f1befa0e4c121de7c3424d4" => :yosemite
    sha256 "e0d1f1cb2994446692b634e13194e9a470346c4025b42173e7206550aa059c37" => :mavericks
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
