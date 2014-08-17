require 'formula'

class Llvm < Formula
  homepage 'http://llvm.org/'

  bottle do
    sha1 "8136d3ef9c97e3de20ab4962f94a6c15ce5b50b2" => :mavericks
    sha1 "15d12d15f17c3fa12f2b7e87ac1f70ae3eaa7e35" => :mountain_lion
    sha1 "50e1d0c4a046ea14fb8c4bbd305bc7c8ccaac5bb" => :lion
  end

  stable do
    url "http://llvm.org/releases/3.4.2/llvm-3.4.2.src.tar.gz"
    sha1 "c5287384d0b95ecb0fd7f024be2cdfb60cd94bc9"
    resource 'clang' do
      url "http://llvm.org/releases/3.4.2/cfe-3.4.2.src.tar.gz"
      sha1 "add5420b10c3c3a38c4dc2322f8b64ba0a5def97"
    end
    resource 'lld' do
      url "http://llvm.org/releases/3.4/lld-3.4.src.tar.gz"
      sha1 "1e8f2fe693d82fd0e3166fb60e017720eb1a5cf5"
    end
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk", :using => :svn
    resource 'clang' do
      url "http://llvm.org/svn/llvm-project/cfe/trunk", :using => :svn
    end
    resource 'lld' do
      url "http://llvm.org/svn/llvm-project/lld/trunk", :using => :svn
    end
  end

  option :universal
  option 'with-clang', 'Build Clang support library'
  option 'with-lld', 'Build LLD linker'
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

    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"

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
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_share}/llvm.

      If you already have LLVM installed, then "brew upgrade llvm" might not work.
      Instead, try:
          brew rm llvm && brew install llvm
    EOS
  end
end
