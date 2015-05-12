class Llvm < Formula
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz"
    sha256 "b39a69e501b49e8f73ff75c9ad72313681ee58d6f430bfad4d81846fe92eb9ce"

    resource "clang" do
      url "http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz"
      sha256 "be0e69378119fe26f0f2f74cffe82b7c26da840c9733fe522ed3c1b66b11082d"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.0/libcxx-3.6.0.src.tar.xz"
      sha256 "299c1e82b0086a79c5c1aa1885ea3be3bbce6979aaa9b886409b14f9b387fbb7"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.6.0/lld-3.6.0.src.tar.xz"
      sha256 "fb6f787188485b1fac17b73eed9db1dbc0481d6d1fbc273ea1fcd51fdb49a230"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.6.0/lldb-3.6.0.src.tar.xz"
      sha256 "2b1ad1d42c4ea3fa2f9dd6db7c522d86e80891659b24dbb3d0d80386d8eaf0b2"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.6.0/clang-tools-extra-3.6.0.src.tar.xz"
      sha256 "3aa949ba82913490a75697287d9ee8598c619fae0aa6bb8fddf0095ff51bc812"
    end
  end

  bottle do
    sha256 "a1788dcad685a25e4851885c0081347d146783ec2e5ef23c55bdbfd5b29e2869" => :yosemite
    sha256 "bdeecd4844420bedbdf80947c25a125aa275fb69657388c15a316d00e4774133" => :mavericks
    sha256 "a9c45cff37c72cb17dc00eb5ce34ca9f91a0812f3194492e6e6a90c4160f2849" => :mountain_lion
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
  option "with-python", "Build Python bindings against Homebrew Python"
  option "without-shared", "Don't build LLVM as a shared library"
  option "without-assertions", "Speeds up LLVM, but provides less debug information"

  deprecated_option "rtti" => "with-rtti"
  deprecated_option "disable-shared" => "without-shared"
  deprecated_option "disable-assertions" => "without-assertions"

  if MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional
  end
  depends_on "cmake" => :build
  depends_on "swig" if build.with? "lldb"

  keg_only :provided_by_osx

  # Apple's libstdc++ is too old to build LLVM
  fails_with :gcc
  fails_with :llvm

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    if build.with?("lldb") && build.without?("clang")
      raise "Building LLDB needs Clang support library."
    end

    if build.with? "clang"
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"tools/clang").install resource("clang")
      (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    end

    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"
    (buildpath/"tools/lldb").install resource("lldb") if build.with? "lldb"

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=On
    ]

    args << "-DLLVM_ENABLE_RTTI=On" if build.with? "rtti"

    args << "-DBUILD_SHARED_LIBS=Off" if build.without? "shared"

    args << "-DLLVM_ENABLE_ASSERTIONS=On" if build.with? "assertions"

    if build.universal?
      ENV.permit_arch_flags
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

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
