class Llvm < Formula
  homepage 'http://llvm.org/'
  revision 2

  stable do
    url "http://llvm.org/releases/3.5.0/llvm-3.5.0.src.tar.xz"
    sha1 "58d817ac2ff573386941e7735d30702fe71267d5"

    resource "clang" do
      url "http://llvm.org/releases/3.5.0/cfe-3.5.0.src.tar.xz"
      sha1 "834cee2ed8dc6638a486d8d886b6dce3db675ffa"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.5.0/libcxx-3.5.0.src.tar.xz"
      sha1 "c98beed86ae1adf9ab7132aeae8fd3b0893ea995"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.5.0/lld-3.5.0.src.tar.xz"
      sha1 "13c88e1442b482b3ffaff5934f0a2b51cab067e5"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.5.0/clang-tools-extra-3.5.0.src.tar.xz"
      sha1 "74a84493e3313c180490a4affbb92d61ee4f0d21"
    end
  end

  bottle do
    sha1 "b438ffa15440a1f6ee7efbc7ddc3adb32e757ad6" => :yosemite
    sha1 "47e4f98e8fa4ea845f5acd6ea568b9ddc73729df" => :mavericks
    sha1 "244cb85540b4ec6a33356e3e02fd8e0caa89224d" => :mountain_lion
  end

  head do
    url "http://llvm.org/git/llvm.git"

    resource "clang" do
      url "http://llvm.org/git/clang.git"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/git/clang-tools-extra.git"
    end
  end

  # Use absolute paths for shared library IDs
  patch :DATA

  option :universal
  option 'with-clang', 'Build Clang support library'
  option 'with-lld', 'Build LLD linker'
  option 'disable-shared', "Don't build LLVM as a shared library"
  option 'all-targets', 'Build all target backends'
  option 'rtti', 'Build with C++ RTTI'
  option 'disable-assertions', 'Speeds up LLVM, but provides less debug information'

  depends_on :python => :optional

  keg_only :provided_by_osx

  # Apple's libstdc++ is too old to build LLVM
  fails_with :gcc
  fails_with :llvm

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    if build.with? "python" and build.include? 'disable-shared'
      raise 'The Python bindings need the shared library.'
    end

    if build.with? "clang"
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"tools/clang").install resource("clang")
      (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    end

    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"

    if build.universal?
      ENV.permit_arch_flags
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = Hardware::CPU.universal_archs.join(' ')
    end

    ENV["REQUIRES_RTTI"] = "1" if build.include? "rtti" or build.with? "clang"

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
    system "make"
    system "make", "install"

    if build.with? "clang"
      system "make", "-C", "projects/libcxx", "install",
        "DSTROOT=#{prefix}", "SYMROOT=#{buildpath}/projects/libcxx"

      (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
      inreplace "#{share}/clang/tools/scan-build/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
      bin.install_symlink share/"clang/tools/scan-build/scan-build", share/"clang/tools/scan-view/scan-view"
      man1.install_symlink share/"clang/tools/scan-build/scan-build.1"
    end

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
    EOS
  end
end

__END__
diff --git a/Makefile.rules b/Makefile.rules
index ebebc0a..b0bb378 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -599,7 +599,12 @@ ifneq ($(HOST_OS), $(filter $(HOST_OS), Cygwin MingW))
 ifneq ($(HOST_OS),Darwin)
   LD.Flags += $(RPATH) -Wl,'$$ORIGIN'
 else
-  LD.Flags += -Wl,-install_name  -Wl,"@rpath/lib$(LIBRARYNAME)$(SHLIBEXT)"
+  LD.Flags += -Wl,-install_name
+  ifdef LOADABLE_MODULE
+    LD.Flags += -Wl,"$(PROJ_libdir)/$(LIBRARYNAME)$(SHLIBEXT)"
+  else
+    LD.Flags += -Wl,"$(PROJ_libdir)/$(SharedPrefix)$(LIBRARYNAME)$(SHLIBEXT)"
+  endif
 endif
 endif
 endif
