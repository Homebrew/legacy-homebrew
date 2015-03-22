class Llvm < Formula
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz"
    sha1 "6eb2b7381d924bb3f267281c9058c817d825d824"

    resource "clang" do
      url "http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz"
      sha1 "06b252867a3d118c95ca279fd3c4ac05f6730551"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.0/libcxx-3.6.0.src.tar.xz"
      sha1 "5445194366ae2291092fd2204030cb3d01ad6272"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.6.0/lld-3.6.0.src.tar.xz"
      sha1 "3d6e47c13e93530126eebc45f008d3dcaa6dd7d2"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.6.0/lldb-3.6.0.src.tar.xz"
      sha1 "f92c4bb7d9f0431285d068668b10d62512f36f03"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.6.0/clang-tools-extra-3.6.0.src.tar.xz"
      sha1 "30c6acd7404b9abf0338110818fba255d5744978"
    end
  end

  bottle do
    sha1 "3e2dd43db3c45a3bcf96174e0b195267f66f0307" => :yosemite
    sha1 "e0314fabbc5791fb665225ca91602b3fdd745072" => :mavericks
    sha1 "59857e2f5670c9edb4adfd3cc3f03af2411e9c30" => :mountain_lion
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

    resource "lldb" do
      url "http://llvm.org/git/lldb.git"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/git/clang-tools-extra.git"
    end
  end

  # Use absolute paths for shared library IDs
  patch :DATA

  option :universal
  option "with-clang", "Build Clang support library"
  option "with-lld", "Build LLD linker"
  option "with-lldb", "Build LLDB debugger"
  option "with-rtti", "Build with C++ RTTI"
  option "with-all-targets", "Build all target backends"
  option "with-python", "Build Python bindings against Homebrew Python"
  option "without-shared", "Don't build LLVM as a shared library"
  option "without-assertions", "Speeds up LLVM, but provides less debug information"

  deprecated_option "rtti" => "with-rtti"
  deprecated_option "all-targets" => "with-all-targets"
  deprecated_option "disable-shared" => "without-shared"
  deprecated_option "disable-assertions" => "without-assertions"

  if MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional
  end
  depends_on "swig" if build.with? "lldb"

  keg_only :provided_by_osx

  # Apple's libstdc++ is too old to build LLVM
  fails_with :gcc
  fails_with :llvm

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    if build.with?("lldb") && build.without?("clang")
      fail "Building LLDB needs Clang support library."
    end

    if build.with? "clang"
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"tools/clang").install resource("clang")
      (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    end

    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"
    (buildpath/"tools/lldb").install resource("lldb") if build.with? "lldb"

    if build.universal?
      ENV.permit_arch_flags
      ENV["UNIVERSAL"] = "1"
      ENV["UNIVERSAL_ARCH"] = Hardware::CPU.universal_archs.join(" ")
    end

    ENV["REQUIRES_RTTI"] = "1" if build.with?("rtti") || build.with?("clang")

    args = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      # As of LLVM 3.1, attempting to build ocaml bindings with Homebrew's
      # OCaml 3.12.1 results in errors.
      "--disable-bindings",
    ]

    if build.with? "all-targets"
      args << "--enable-targets=all"
    else
      args << "--enable-targets=host"
    end
    args << "--enable-shared" if build.with? "shared"

    args << "--disable-assertions" if build.without? "assertions"

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
    (lib+"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib+"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang" if build.with? "clang"
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
