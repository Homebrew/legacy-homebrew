require 'formula'

class Llvm < Formula
  homepage 'http://llvm.org/'
  url "http://llvm.org/releases/3.4.1/llvm-3.4.1.src.tar.gz"
  sha1 "3711baa6f5ef9df07418ce76039fc3848a7bde7c"

  bottle do
    sha1 "92dc1d8793000d05c8321b2791b6b1d7321a83c3" => :mavericks
    sha1 "a46bd08a60fd7ae17a21476bbb810510b58d492a" => :mountain_lion
    sha1 "4dfc0268acc552bd62b2954ac3829802b25a5a46" => :lion
  end

  resource 'clang' do
    url "http://llvm.org/releases/3.4.1/cfe-3.4.1.src.tar.gz"
    sha1 "ecd38fa89e837e6cb8305b8d05e88baecb0bda55"
  end

  option :universal
  option 'with-clang', 'Build Clang support library'
  option 'disable-shared', "Don't build LLVM as a shared library"
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'
  option 'disable-assertions', 'Speeds up LLVM, but provides less debug information'

  depends_on :python => :optional

  keg_only :provided_by_osx

  def install
    if build.with? "python" and build.include? 'disable-shared'
      raise 'The Python bindings need the shared library.'
    end

    (buildpath/"tools/clang").install resource("clang") if build.with? "clang"

    if build.universal?
      ENV.permit_arch_flags
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = Hardware::CPU.universal_archs.join(' ')
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
    system 'make'
    system 'make', 'install'

    (share/'llvm/cmake').install buildpath/'cmake/modules'

    # install llvm python bindings
    if build.with? "python"
      (lib+'python2.7/site-packages').install buildpath/'bindings/python/llvm'
      (lib+'python2.7/site-packages').install buildpath/'tools/clang/bindings/python/clang' if build.with? 'clang'
    end
  end

  test do
    system "#{bin}/llvm-config", "--version"
  end

  def caveats
    <<-EOS.undent
      LLVM executables are installed in #{bin}.
      Extra tools are installed in #{share}/llvm.

      If you already have LLVM installed, then "brew upgrade llvm" might not work.
      Instead, try:
          brew rm llvm && brew install llvm
    EOS
  end
end
