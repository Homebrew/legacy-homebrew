require 'formula'

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.2/clang-3.2.src.tar.gz'
  sha1      'b0515298c4088aa294edc08806bd671f8819f870'

  head      'http://llvm.org/git/clang.git'
end

class CompilerRt < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.2/compiler-rt-3.2.src.tar.gz'
  sha1      '718c0249a00e928f8bba32c84771da998ea4d42f'

  head      'http://llvm.org/git/compiler-rt.git'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.2/llvm-3.2.src.tar.gz'
  sha1      '42d139ab4c9f0c539c60f5ac07486e9d30fc1280'

  head      'http://llvm.org/git/llvm.git'

  bottle do
    revision 1
    sha1 '2908621be867da84962d2e4b8d6a083bd6bf4995' => :mountain_lion
    sha1 '91dfa26392b9699750a04fa934ee8ec9dc98407a' => :lion
    sha1 '259f39608d50dd3aba0eb3ff28b603d795af9eac' => :snow_leopard
  end

  option :universal
  option 'with-clang', 'Build Clang C/ObjC/C++ frontend'
  option 'with-asan', 'Include support for -faddress-sanitizer (from compiler-rt)'
  option 'shared', 'Build LLVM as a shared library'
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'
  option 'disable-assertions', 'Speeds up LLVM, but provides less debug information'

  def install
    if build.universal? and build.include? 'shared'
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    Clang.new("clang").brew do
      clang_dir.install Dir['*']
    end if build.include? 'with-clang'

    CompilerRt.new("compiler-rt").brew do
      (buildpath/'projects/compiler-rt').install Dir['*']
    end if build.include? 'with-asan'

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

    args << "--disable-assertions" if build.include? 'disable-assertions'

    system "./configure", *args
    system "make install"

    # install llvm python bindings
    (share/'llvm/bindings').install buildpath/'bindings/python'

    # install clang tools and bindings
    cd clang_dir do
      system 'make install'
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
