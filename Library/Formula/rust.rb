require 'formula'

class Rust < Formula
  url 'http://dl.rust-lang.org/dist/rust-0.1.tar.gz'
  homepage 'http://www.rust-lang.org/'
  md5 '80b655bcceaf2192c502a692c8c1eb20'

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
