require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'

  stable do
    url 'http://static.rust-lang.org/dist/rust-0.8.tar.gz'
    sha256 '42f791ab1537357fe0f63d67ffe6bcb64ecf16b2bd3f1484ab589823f5914182'

    depends_on :xcode # for gyp; fixed in HEAD
  end

  head 'https://github.com/mozilla/rust.git'

  bottle do
    sha1 '50205c9ff28940ffa04b1337698ae1c57053dae0' => :mavericks
    sha1 'f7a2b190a6115352997b588d06982a27da87df3a' => :mountain_lion
    sha1 '5d4590ff8a52bd184ba48ae5932077f04b0db939' => :lion
  end

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-clang" if ENV.compiler == :clang
    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rustc"
    system "#{bin}/rustdoc -h"
    system "#{bin}/rustpkg -v"
  end
end
