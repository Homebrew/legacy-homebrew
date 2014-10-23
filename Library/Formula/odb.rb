require "formula"

class Odb < Formula
  homepage "http://www.codesynthesis.com/products/odb"
  url "http://www.codesynthesis.com/download/odb/2.3/odb-2.3.0.tar.gz"
  sha1 "53c851e3f3724b72d7c7a74c497c50c195729ad1"

  fails_with :clang
  fails_with :gcc_4_0
  fails_with :gcc
  fails_with :llvm
  
  depends_on "gcc"

  resource "libcutl" do
    url "http://www.codesynthesis.com/download/libcutl/1.8/libcutl-1.8.1.tar.gz"
    sha1 "5411892a2959b6164321ebfb6e8e52255786b143"
  end
  
  patch do
    url "http://codesynthesis.com/~boris/tmp/odb/odb-2.3.0-gcc-4.9.0.patch"
    sha1 "9d0fe9db9d8667c76cd6a1bb15e911560796b656"
  end

  def install
    print HOMEBREW_PREFIX.class
    resource("libcutl").stage{
      system "./configure", "--prefix=#{prefix}/libcutl"
      system "make", "install"
    }
    ENV.append "CXXFLAGS", "-fno-devirtualize -I#{prefix}/libcutl/include -L#{prefix}/libcutl/lib"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    #HOMEBREW_PREFIX.install_symlink libexec/"odb.so"
  end

  test do
    system "odb", "--help"
  end

end
