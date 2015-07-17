class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      touch "llvm_check.txt"
      quiet_system "/usr/bin/codesign", "-s", "lldb_codesign", "llvm_check.txt"
    end
  end

  def message
    <<-EOS.undent
      lldb_codesign identity must be available to build with LLDB.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class Llvm < Formula
  desc "llvm (Low Level Virtual Machine): a next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.6.1/llvm-3.6.1.src.tar.xz"
    sha256 "2f00c615913aa0b56607ee1548936e60ad2aa89e6d56f23fb032a4463366fc7a"

    resource "clang" do
      url "http://llvm.org/releases/3.6.1/cfe-3.6.1.src.tar.xz"
      sha256 "74f92d0c93b86678b015e87655f59474b2f657769680efdeb3c0524ffbd2dad7"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.1/libcxx-3.6.1.src.tar.xz"
      sha256 "5a5c653becf3978d4c4f6095708660855bed691210a9426bb839eecd88b6c0f9"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.6.1/lld-3.6.1.src.tar.xz"
      sha256 "3aee0513caeac6dd55930838425f63ad79bee9ccdf081cafbd853bbd65486feb"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.6.1/lldb-3.6.1.src.tar.xz"
      sha256 "cefb5c64e78e85ad05a06b80f017ccfe1208b74d3da34eb425c505c6fef9aaba"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.6.1/clang-tools-extra-3.6.1.src.tar.xz"
      sha256 "f4ee70d870d550a9147ac6a548ce7daf7d9e6897348bf411f43c572966fb92b6"
    end
  end

  bottle do
    revision 1
    sha256 "54c815d99473ef948bee29b577315461a140117b874396fda617a5c7d1bdbb0b" => :yosemite
    sha256 "2be603591104a91d0a16ba5a6231717d5252ef860e83af620fbc5d10394fcb61" => :mavericks
    sha256 "3996bbf655ae2c8457304f41d2c3df0b96f307f9fb624417c76afa75d3b587c0" => :mountain_lion
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

  option :universal
  option "with-clang", "Build Clang support library"
  option "with-lld", "Build LLD linker"
  option "with-lldb", "Build LLDB debugger"
  option "with-rtti", "Build with C++ RTTI"
  option "with-python", "Build Python bindings against Homebrew Python"
  option "without-assertions", "Speeds up LLVM, but provides less debug information"

  deprecated_option "rtti" => "with-rtti"
  deprecated_option "disable-assertions" => "without-assertions"

  if MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional
  end
  depends_on "cmake" => :build

  if build.with? "lldb"
    depends_on "swig"
    depends_on CodesignRequirement
  end

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

    if build.with? "assertions"
      args << "-DLLVM_ENABLE_ASSERTIONS=On"
    else
      args << "-DCMAKE_CXX_FLAGS_RELEASE='-DNDEBUG'"
    end

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
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang" if build.with? "clang"
  end

  def caveats
    <<-EOS.undent
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_share}/llvm.
    EOS
  end

  test do
    system "#{bin}/llvm-config", "--version"
  end
end
