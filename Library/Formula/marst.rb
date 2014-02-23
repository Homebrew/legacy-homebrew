require "formula"

class Marst < Formula
  homepage "http://www.gnu.org/software/marst"
  url "http://ftpmirror.gnu.org/marst/marst-2.7.tar.gz"
  sha1 "a55ef653887c09045f04e00a179309463546f548"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'hello.alg').write('begin outstring(1, "Hello, world!\n") end')
    system "#{bin}/marst -o hello.c hello.alg"
    system "#{ENV.cc} hello.c -lalgol -lm -o hello"
    system "./hello"
  end
end
