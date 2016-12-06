require 'formula'

class Rust < Formula
  url 'http://dl.rust-lang.org/dist/rust-0.1.tar.gz'
  homepage 'http://rust-lang.org/'
  md5 '80b655bcceaf2192c502a692c8c1eb20'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make && make install"
  end

  def test
    # Compile a simple hello world application
    File.open('/tmp/hello.rs','w') do |f|
      f.write <<-EOS.undent
      use std;
      import std::io;

      fn main() {
          for i in [1, 2, 3] {
              io::println(#fmt("hello %d", i));
          }
      }
      EOS
    end
    system "#{bin}/rustc /tmp/hello.rs"
  end
end
