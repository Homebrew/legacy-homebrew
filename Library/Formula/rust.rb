require 'formula'

class Rust < Formula
  url 'http://dl.rust-lang.org/dist/rust-0.2.tar.gz'
  homepage 'http://www.rust-lang.org/'
  md5 '47be90f952ec01c3088af58be78fd618'

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
