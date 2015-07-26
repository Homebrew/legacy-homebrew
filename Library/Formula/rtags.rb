class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag => "v2.0",
      :revision => "ba85598841648490e64246be802fc2dcdd45bc3c"

  head "https://github.com/Andersbakken/rtags.git"

  depends_on "cmake" => :build
  depends_on "llvm" => "with-clang"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # not using shell_output because on HEAD the exit code will be 0, but on
    # stable it will be 1.
    cmd = "#{bin}/rc --help"
    ohai cmd
    assert_match /rc options/, `#{cmd}`
  end
end
