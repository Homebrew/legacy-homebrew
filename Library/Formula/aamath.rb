require 'formula'

class Aamath < Formula
  homepage 'http://fuse.superglue.se/aamath/'
  url 'http://fuse.superglue.se/aamath/aamath-0.3.tar.gz'
  sha1 'dc68abaf2131c73ddb1a520c95d65596e30f1b0a'

  def install
    ENV.j1
    system "make"

    bin.install "aamath"
    man1.install "aamath.1"
    prefix.install "testcases"
  end

  test do
    IO.popen("#{bin}/aamath", "w+") do |pipe|
      pipe.write((prefix/"testcases").read)
      pipe.close_write
      /#{Regexp.escape("f(x + h) = f(x) + h f'(x)")}/ === pipe.read
    end
  end
end
