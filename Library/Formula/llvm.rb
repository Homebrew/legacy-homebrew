require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end
def build_universal?; ARGV.build_universal?; end
def build_shared?; ARGV.include? '--shared'; end

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.1/clang-3.1.src.tar.gz'
  sha1      '19f33b187a50d22fda2a6f9ed989699a9a9efd62'

  head      'http://llvm.org/git/clang.git'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.1/llvm-3.1.src.tar.gz'
  sha1      '234c96e73ef81aec9a54da92fc2a9024d653b059'

  head      'http://llvm.org/git/llvm.git'

  bottle do
    sha1 'fcf6c3eb5b074afa820f905f32182e074a29ffb5' => :mountainlion
    sha1 '4ee3e9242cff9a03af4e1f20017fe547dcd07a4a' => :lion
    sha1 '940aca37dafaf69a9b378ffd2a59b3c1cfe54ced' => :snowleopard
  end

  def options
    [['--with-clang', 'Build clang C/ObjC/C++ frontend'],
     ['--shared', 'Build llvm as shared library, and link tools against it'],
     ['--all-targets', 'Build all target backends'],
     ['--rtti', 'Build llvm with C++ RTTI, use if you need RTTI of llvm classes'],
     ['--universal', 'Build both i386 and x86_64 architectures']]
  end

  def install
    if build_shared? && build_universal?
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    Clang.new("clang").brew { clang_dir.install Dir['*'] } if build_clang?

    if build_universal?
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = 'i386 x86_64'
    end

    ENV['REQUIRES_RTTI'] = '1' if ARGV.include? '--rtti'

    configure_options = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      # As of LLVM 3.1, attempting to build ocaml bindings with Homebrew's
      # OCaml 3.12.1 results in errors.
      "--disable-bindings",
    ]

    if ARGV.include? '--all-targets'?
      configure_options << "--enable-targets=all"
    else
      configure_options << "--enable-targets=host"
    end
    configure_options << "--enable-shared" if build_shared?

    system "./configure", *configure_options
    system "make install"

    # install llvm python bindings
    (share/'llvm/bindings').install buildpath/'bindings/python'

    # install clang tools and bindings
    cd clang_dir do
      (share/'clang/tools').install 'tools/scan-build', 'tools/scan-view'
      (share/'clang/bindings').install 'bindings/python'
    end if build_clang?
  end

  def test
    system "#{bin}/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    Extra tools and bindings are installed in #{share}/llvm and #{share}/clang.

    If you already have LLVM installed, then "brew upgrade llvm" might not work.
    Instead, try:
        brew rm llvm && brew install llvm
    EOS
  end

  def clang_dir
    buildpath/'tools/clang'
  end
end
