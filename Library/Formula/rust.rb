require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'

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
