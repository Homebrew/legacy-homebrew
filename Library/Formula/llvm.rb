require 'formula'

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

  option :universal
  option 'with-clang', 'Build Clang C/ObjC/C++ frontend'
  option 'shared', 'Build LLVM as a shared library'
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'

  def install
    if build.universal? and build.include? 'shared'
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    Clang.new("clang").brew { clang_dir.install Dir['*'] } if build.include? 'with-clang'

    if build.universal?
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = 'i386 x86_64'
    end

    ENV['REQUIRES_RTTI'] = '1' if build.include? 'rtti'

    args = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      # As of LLVM 3.1, attempting to build ocaml bindings with Homebrew's
      # OCaml 3.12.1 results in errors.
      "--disable-bindings",
    ]

    if build.include? 'all-targets'
      args << "--enable-targets=all"
    else
      args << "--enable-targets=host"
    end
    args << "--enable-shared" if build.include? 'shared'

    system "./configure", *args
    system "make install"

    # install llvm python bindings
    (share/'llvm/bindings').install buildpath/'bindings/python'

    # install clang tools and bindings
    cd clang_dir do
      (share/'clang/tools').install 'tools/scan-build', 'tools/scan-view'
      (share/'clang/bindings').install 'bindings/python'
    end if build.include? 'with-clang'
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
