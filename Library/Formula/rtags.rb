class Rtags < Formula
  homepage "https://github.com/Andersbakken/rtags"

  stable do
    url "https://github.com/Andersbakken/rtags/archive/v2.0.tar.gz"
    sha256 "36733945ea34517903a0e5b800b06a41687ee25d3ab360072568523e5d610d6f"

    resource "rct" do
      url "https://github.com/Andersbakken/rct.git", :revision => "10700c615179f07d4832d459e6453eed736cfaef"
    end
  end

  head "https://github.com/Andersbakken/rtags.git"

  depends_on "cmake" => :build
  depends_on "llvm" => "with-clang"
  depends_on "openssl"

  def install
    unless build.head?
      (buildpath/"src/rct").install resource("rct")
    end

    # we use brew's LLVM instead of the macosx llvm because the macosx one
    # doesn't include libclang.
    ENV.prepend_path "PATH", "#{opt_libexec}/llvm/bin"

    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", '-lc++abi')

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
