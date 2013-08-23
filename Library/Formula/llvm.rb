require 'formula'

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz'
  sha1      'ccd6dbf2cdb1189a028b70bcb8a22509c25c74c8'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz'
  sha1      'c6c22d5593419e3cb47cbcf16d967640e5cce133'

  bottle do
    sha1 '61854a2cf08a1398577f74fea191a749bec3e72d' => :mountain_lion
    sha1 'fbe7b85a50f4b283ad55be020c7ddfbf655435ad' => :lion
    sha1 'f68fdb89d44a72c83db1e55e25444de4dcde5375' => :snow_leopard
  end

  option :universal
  option 'with-clang', 'Build Clang C/ObjC/C++ frontend'
  option 'disable-shared', "Don't build LLVM as a shared library"
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'
  option 'disable-assertions', 'Speeds up LLVM, but provides less debug information'

  depends_on :python => :recommended

  env :std if build.universal?

  def install
    if python and build.include? 'disable-shared'
      raise 'The Python bindings need the shared library.'
    end

    Clang.new("clang").brew do
      (buildpath/'tools/clang').install Dir['*']
    end if build.with? 'clang'

    if build.universal?
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
    system 'make', 'VERBOSE=1'
    system 'make', 'VERBOSE=1', 'install'

    # install llvm python bindings
    if python
      python.site_packages.install buildpath/'bindings/python/llvm'
      python.site_packages.install buildpath/'tools/clang/bindings/python/clang' if build.with? 'clang'
    end

    # Remove all binaries except llvm-config
    rm_f Dir["#{bin}/*"] - Dir["#{bin}/llvm-config"]

    # Remove all man pages
    man.rmtree if build.with? 'clang'
  end

  def test
    system "#{bin}/llvm-config", "--version"
  end

  def caveats
    s = ''
    s += python.standard_caveats if python
    s += <<-EOS.undent
      This formula only provide library components of LLVM. To use full
      featured LLVM please try the llvm3* formulae in homebrew-versions tap,
      for instance:

          brew tap homebrew/versions
          brew install llvm33

      Extra tools are installed in #{share}/llvm and #{share}/clang.

      If you already have LLVM installed, then "brew upgrade llvm" might not work.
      Instead, try:
          brew rm llvm && brew install llvm
    EOS
  end

end
