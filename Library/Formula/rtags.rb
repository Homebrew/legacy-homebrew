class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"

  head "https://github.com/Andersbakken/rtags.git"

  stable do
    url "https://github.com/Andersbakken/rtags.git",
        :tag => "v2.0",
        :revision => "ba85598841648490e64246be802fc2dcdd45bc3c"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => "with-clang"
  depends_on "openssl"

  def install
    # we use brew's LLVM instead of the macosx llvm because the macosx one
    # doesn't include libclang.
    ENV.prepend_path "PATH", "#{opt_libexec}/llvm/bin"

    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    mkdir "build" do
      args = std_cmake_args
      args << ".."

      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "sh", "-c", "rc >/dev/null --help  ; test $? == 1"
  end
end
