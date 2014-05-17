require 'formula'

class Llvm < Formula
  homepage 'http://llvm.org/'
  url 'http://llvm.org/releases/3.4/llvm-3.4.src.tar.gz'
  sha1 '10b1fd085b45d8b19adb9a628353ce347bc136b8'

  bottle do
    sha1 "3f633f71f4ff0e9282e2b68aa45ba51b5179f243" => :mavericks
    sha1 "3dc85e1b34e1671d9c016e50490da061156c6b43" => :mountain_lion
    sha1 "4d49c424a7b0e682eba6e84e92292a4055a3a003" => :lion
  end

  resource 'clang' do
    url 'http://llvm.org/releases/3.4/clang-3.4.src.tar.gz'
    sha1 'a6a3c815dd045e9c13c7ae37d2cfefe65607860d'
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
      Extra tools are installed in #{share}/llvm and #{share}/clang.

      If you already have LLVM installed, then "brew upgrade llvm" might not work.
      Instead, try:
          brew rm llvm && brew install llvm
    EOS
  end
end
