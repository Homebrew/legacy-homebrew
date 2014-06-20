require 'formula'

class Sdl2 < Formula
  homepage 'http://www.libsdl.org/'
  url 'http://libsdl.org/release/SDL2-2.0.3.tar.gz'
  sha1 '21c45586a4e94d7622e371340edec5da40d06ecc'

  bottle do
    cellar :any
    sha1 "33749bf276e522b7a2c14c725d30905e880b3667" => :mavericks
    sha1 "c03011f60cb6099fdeb5726fb39d7fee3d25b8a4" => :mountain_lion
    sha1 "e952fdca85139ccab6f9bcffc90630088760029d" => :lion
  end

  head do
    url 'http://hg.libsdl.org/SDL', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], '@prefix@', HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix}]
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or (ENV.compiler == :clang and MacOS.clang_build_version < 421)
    args << '--without-x'

    system './configure', *args
    system "make install"
  end

  test do
    system "#{bin}/sdl2-config", "--version"
  end
end
