require 'formula'

class Sdl < Formula
  url 'http://www.libsdl.org/release/SDL-1.2.14.tar.gz'
  head 'http://hg.libsdl.org/SDL', :using => :hg
  homepage 'http://www.libsdl.org/'
  md5 'e52086d1b508fa0b76c52ee30b55bec4'

  # we have to do this because most build scripts assume that all sdl modules
  # are installed to the same prefix. Consequently SDL stuff cannot be
  # keg-only but I doubt that will be needed.
  def self.use_homebrew_prefix files
    inreplace files, '@prefix@', HOMEBREW_PREFIX
  end

  def install
    Sdl.use_homebrew_prefix %w[sdl.pc.in sdl-config.in]

    # Sdl assumes X11 is present on UNIX
    ENV.x11
    system "./autogen.sh" if ARGV.build_head?

    args = %W[--prefix=#{prefix} --disable-nasm]
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or ENV.compiler == :clang

    system './configure', *args
    system "make install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"]
  end
end
