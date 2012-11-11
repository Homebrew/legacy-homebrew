require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://dl.rust-lang.org/dist/rust-0.4.tar.gz'
  sha256 '150685f07e4d605cadf9fba25b05e9cc1b009364dd744131cf4230d64981d093'

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
