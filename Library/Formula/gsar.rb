class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "http://tjaberg.com/"
  url "http://tjaberg.com/gsar121.zip"
  version "1.21"
  sha256 "05fb9583c970aba4eb0ffae2763d7482b0697c65fda1632a247a0153d7db65a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cf3fe6d772f95378e2802a6208b8f06524a81b4d881343571dd3af201b69e98" => :el_capitan
    sha256 "6e138e63b868dfbd4d16109cabe60f50dc600fd65cbf14cd3926b1b8c2f3e2dc" => :yosemite
    sha256 "3911e63bccd5deae4101c7c38a84954ad7e205bda69b3eefcee61a4d46e1df8d" => :mavericks
  end

  def install
    system "make"
    bin.install "gsar"
  end

  test do
    assert_match /1 occurrence changed/, shell_output("#{bin}/gsar -sCourier -rMonaco #{test_fixtures("test.ps")} new.ps")
  end
end
