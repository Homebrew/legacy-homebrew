require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
<<<<<<< HEAD
  url 'http://dl.rust-lang.org/dist/rust-0.3.tar.gz'
  sha256 'b34c895b9596abb6942d1688e6a5189b08b92e2507234779779c1af91e9ae84e'
=======
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rustc"
    system "#{bin}/rustdoc"
    system "#{bin}/cargo"
  end
end
