require 'formula'

class Llvm < Formula
  homepage 'http://llvm.org/'

  bottle do
    sha1 "8136d3ef9c97e3de20ab4962f94a6c15ce5b50b2" => :mavericks
    sha1 "15d12d15f17c3fa12f2b7e87ac1f70ae3eaa7e35" => :mountain_lion
    sha1 "50e1d0c4a046ea14fb8c4bbd305bc7c8ccaac5bb" => :lion
  end

  stable do
    url "http://llvm.org/releases/3.5.0/llvm-3.5.0.src.tar.xz"
    sha1 "58d817ac2ff573386941e7735d30702fe71267d5"
    resource 'clang' do
      url "http://llvm.org/releases/3.5.0/cfe-3.5.0.src.tar.xz"
      sha1 "834cee2ed8dc6638a486d8d886b6dce3db675ffa"
    end
    resource 'lld' do
      url "http://llvm.org/releases/3.5.0/lld-3.5.0.src.tar.xz"
      sha1 "13c88e1442b482b3ffaff5934f0a2b51cab067e5"
    end
    fails_with :clang if MacOS.version < :mavericks
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
