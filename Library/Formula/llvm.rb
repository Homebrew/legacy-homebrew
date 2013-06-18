require 'formula'

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz'
  sha1      'ccd6dbf2cdb1189a028b70bcb8a22509c25c74c8'

  head      'http://llvm.org/git/clang.git'
end

class CompilerRt < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.3/compiler-rt-3.3.src.tar.gz'
  sha1      '745386ec046e3e49742e1ecb6912c560ccd0a002'

  head      'http://llvm.org/git/compiler-rt.git'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz'
  sha1      'c6c22d5593419e3cb47cbcf16d967640e5cce133'

  head      'http://llvm.org/git/llvm.git'

  option :universal
  option 'with-clang', 'Build Clang C/ObjC/C++ frontend'
  option 'with-asan', 'Include support for -faddress-sanitizer (from compiler-rt)'
  option 'disable-shared', "Don't build LLVM as a shared library"
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'
  option 'disable-assertions', 'Speeds up LLVM, but provides less debug information'

  depends_on :python => :recommended

  env :std if build.universal?

  def install
    if build.with? 'python' and build.include? 'disable-shared'
      raise 'The Python bindings need the shared library.'
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
    args << "--enable-shared" unless build.include? 'disable-shared'

    args << "--disable-assertions" if build.include? 'disable-assertions'

    system "./configure", *args
    system "make install"

    # install llvm python bindings
    if python
      unless build.head?
        inreplace buildpath/'bindings/python/llvm/common.py', 'LLVM-3.1svn', "libLLVM-#{version}svn"
      end
      python.site_packages.install buildpath/'bindings/python/llvm'
    end

    # install clang tools and bindings
    cd clang_dir do
      system 'make install'
      (share/'clang/tools').install 'tools/scan-build', 'tools/scan-view'
      python.site_packages.install 'bindings/python/clang' if python
    end if build.include? 'with-clang'
  end

  def test
    system "#{bin}/llvm-config", "--version"
  end

  def caveats
    s = ''
    s += python.standard_caveats if python
    s += <<-EOS.undent
      Extra tools are installed in #{share}/llvm and #{share}/clang.

      If you already have LLVM installed, then "brew upgrade llvm" might not work.
      Instead, try:
          brew rm llvm && brew install llvm
    EOS
  end

  def clang_dir
    buildpath/'tools/clang'
  end
end
