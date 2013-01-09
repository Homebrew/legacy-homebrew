require 'formula'

class Sdl < Formula
  homepage 'http://www.libsdl.org/'
  url 'http://www.libsdl.org/release/SDL-1.2.15.tar.gz'
  sha1 '0c5f193ced810b0d7ce3ab06d808cbb5eef03a2c'

  head 'http://hg.libsdl.org/SDL', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    if build.stable?
      inreplace %w[sdl.pc.in sdl-config.in], '@prefix@', HOMEBREW_PREFIX
    else
      inreplace %w[sdl2.pc.in sdl2-config.in], '@prefix@', HOMEBREW_PREFIX
    end

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix}]
    args << "--disable-nasm" unless MacOS.version >= :mountain_lion # might work with earlier, might only work with new clang
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or (ENV.compiler == :clang and MacOS.clang_build_version < 421)
    args << '--without-x'

    system './configure', *args
    system "make install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"] unless build.head?
  end

  def test
    system "#{bin}/sdl-config", "--version"
  end
end
