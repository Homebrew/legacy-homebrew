require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://dl.rust-lang.org/dist/rust-0.3.tar.gz'
  sha256 'b34c895b9596abb6942d1688e6a5189b08b92e2507234779779c1af91e9ae84e'
=======
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'http://dl.rust-lang.org/dist/rust-0.5.tar.gz'
  sha256 'd326d22707f0562d669c11efbc33ae812ddbf76ab78f07087fc5beb095a8928a'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  # Fix repl showstopper bug; can be removed for 0.6.
  # and add clang 4.2 support for new XCode
  def patches
    [ "https://github.com/mozilla/rust/commit/9bf87bbf66227c132283ae59720f919601de9a56.patch",
    "https://github.com/mozilla/rust/commit/37f97ff5041839aa42892115de954489f9eab5bc.patch",
    "https://github.com/labria/rust/commit/b4133cc1236197d0a3ce6f8664827f89277315fe.patch",
    "https://github.com/mozilla/rust/commit/3ee1d3ebb81de199fc630a86933ac18c0a869482.patch" ]
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
    system "#{bin}/rustdoc"
    system "#{bin}/cargo"
  end
end
