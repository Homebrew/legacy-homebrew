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
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"
  revision 1

  stable do
    url "http://llvm.org/releases/3.6.2/llvm-3.6.2.src.tar.xz"
    sha256 "f60dc158bfda6822de167e87275848969f0558b3134892ff54fced87e4667b94"

    resource "clang" do
      url "http://llvm.org/releases/3.6.2/cfe-3.6.2.src.tar.xz"
      sha256 "ae9180466a23acb426d12444d866b266ff2289b266064d362462e44f8d4699f3"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/releases/3.6.2/clang-tools-extra-3.6.2.src.tar.xz"
      sha256 "6a0ec627d398f501ddf347060f7a2ccea4802b2494f1d4fd7bda3e0442d04feb"
    end

    resource "compiler-rt" do
      url "http://llvm.org/releases/3.6.2/compiler-rt-3.6.2.src.tar.xz"
      sha256 "0f2ff37d80a64575fecd8cf0d5c50f7ac1f837ddf700d1855412bb7547431d87"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.2/libcxx-3.6.2.src.tar.xz"
      sha256 "52f3d452f48209c9df1792158fdbd7f3e98ed9bca8ebb51fcd524f67437c8b81"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.6.2/lld-3.6.2.src.tar.xz"
      sha256 "43f553c115563600577764262f1f2fac3740f0c639750f81e125963c90030b33"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.6.2/lldb-3.6.2.src.tar.xz"
      sha256 "940dc96b64919b7dbf32c37e0e1d1fc88cc18e1d4b3acf1e7dfe5a46eb6523a9"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "844303abab16526635eab9a8302a9615be1a06065ae2a9d12e8b2def7d0f1528" => :el_capitan
    sha256 "1c086b886d00e18d4f959c3038307bce90f647d84e8ce15e656362c8b6953808" => :yosemite
    sha256 "4805dbeef4754db9f0ae1aae2497a4f907adb52d323124177266f441686e327f" => :mavericks
  end

  head do
    url "http://llvm.org/git/llvm.git"

    resource "clang" do
      url "http://llvm.org/git/clang.git"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "http://llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git"
    end

    resource "libcxxabi" do
      url "http://llvm.org/git/libcxxabi.git"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "http://llvm.org/git/lldb.git"
    end

    # Polly is --HEAD-only because it requires isl and the version of Polly
    # shipped with 3.6.2 only compiles with isl 0.14 and earlier (current
    # version is 0.15). isl is distributed with the Polly source code from LLVM
    # 3.7 and up, so --HEAD builds do not need to depend on homebrew isl.
    option "with-polly", "Build with the experimental Polly optimizer"
    resource "polly" do
      url "http://llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_osx

  option :universal
  option "with-clang-extra-tools", "Build extra tools for Clang"
  option "with-compiler-rt", "Build Clang runtime support libraries for code sanitizers, builtins, and profiling"
  option "with-libcxx", "Build the libc++ standard library"
  option "with-lld", "Build LLD linker"
  option "with-lldb", "Build LLDB debugger"
  option "with-python", "Build Python bindings against Homebrew Python"
  option "without-clang", "Do not build the Clang compiler and support libraries"
  option "without-rtti", "Build without C++ RTTI"

  deprecated_option "rtti" => "with-rtti"

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

  # Apple's libstdc++ is too old to build LLVM
  fails_with :gcc
  fails_with :llvm

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang") if build.with? "clang"

    if build.with? "clang-extra-tools"
      odie "--with-extra-tools requires --with-clang" if build.without? "clang"
      (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    end

    if build.with? "libcxx"
      (buildpath/"projects/libcxx").install resource("libcxx")
    end

    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"

    if build.with? "lldb"
      odie "--with-lldb requires --with-clang" if build.without? "clang"
      (buildpath/"tools/lldb").install resource("lldb")

      # Building lldb requires a code signing certificate.
      # The instructions provided by llvm creates this certificate in the
      # user's login keychain. Unfortunately, the login keychain is not in
      # the search path in a superenv build. The following three lines add
      # the login keychain to ~/Library/Preferences/com.apple.security.plist,
      # which adds it to the superenv keychain search path.
      mkdir_p "#{ENV["HOME"]}/Library/Preferences"
      username = ENV["USER"]
      system "security", "list-keychains", "-d", "user", "-s", "/Users/#{username}/Library/Keychains/login.keychain"
    end

    if build.with? "polly"
      odie "--with-polly requires --with-clang" if build.without? "clang"
      (buildpath/"tools/polly").install resource("polly")
    end

    if build.with? "compiler-rt"
      odie "--with-compiler-rt requires --with-clang" if build.without? "clang"
      (buildpath/"projects/compiler-rt").install resource("compiler-rt")

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags
    end

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=On
    ]

    args << "-DLLVM_ENABLE_RTTI=On" if build.with? "rtti"

    if build.universal?
      ENV.permit_arch_flags
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DLINK_POLLY_INTO_TOOLS:Bool=ON" if build.with? "polly"

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

    if build.with? "clang"
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
    s = <<-EOS.undent
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_share}/llvm.
    EOS

    if build.with? "libcxx"
      s += <<-EOS.undent
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib} -lc++abi"
      EOS
    end

    s
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
