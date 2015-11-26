class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      touch "llvm_check.txt"
      quiet_system "/usr/bin/codesign", "-s", "lldb_codesign", "--dryrun", "llvm_check.txt"
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
    url "http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz"
    sha256 "ab45895f9dcdad1e140a3a79fd709f64b05ad7364e308c0e582c5b02e9cc3153"

    resource "clang" do
      url "http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz"
      sha256 "4ed740c5a91df1c90a4118c5154851d6a475f39a91346bdf268c1c29c13aa1cc"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.7.0/libcxx-3.7.0.src.tar.xz"
      sha256 "c18f3c8333cd7e678c1424a57fe5e25efe740ca7caf62ac67152b4723f3ad08e"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.7.0/lld-3.7.0.src.tar.xz"
      sha256 "ddb658b789c501efbe4f54ff8ced2c07cd9ff686c92445d8a1ab2cd5dbd837ed"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.7.0/lldb-3.7.0.src.tar.xz"
      sha256 "f4d7505bc111044eaa4033af012221e492938405b62522b8e3e354c20c4b71e9"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.7.0/clang-tools-extra-3.7.0.src.tar.xz"
      sha256 "8ae8a0a3a96b7a700412d67df0af172cb2fc1326beec575fcc0f71d2e72709cd"
    end
  end

  bottle do
    cellar :any
    sha256 "fa04afc62800a236e32880efe30e1dbb61eace1e7e9ec20d2d53393ef9d68636" => :el_capitan
    sha256 "a0ec4b17ae8c1c61071e603d0dcf3e1c39a5aae63c3f8237b4363a06701a3319" => :yosemite
    sha256 "17a62c19d119c88972fa3dce920cfbc6150af8892ba8e29ce551ae7e2e84f42e" => :mavericks
    sha256 "6d780faae2647ebce704b2f0a246b52d4037ebf4a2f796644814607e7751af93" => :mountain_lion
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
      if build.head?
        inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"
      else
        inreplace "#{share}/clang/tools/scan-build/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/scan-build", share/"clang/tools/scan-view/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/scan-build.1"
      end
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
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    if build.with? "clang"
      (testpath/"test.cpp").write <<-EOS.undent
        #include <iostream>
        using namespace std;

        int main()
        {
          cout << "Hello World!" << endl;
          return 0;
        }
      EOS
      system "#{bin}/clang++", "test.cpp", "-o", "test"
      system "./test"
    end
  end
end
