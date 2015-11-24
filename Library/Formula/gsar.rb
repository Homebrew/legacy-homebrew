class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "http://tjaberg.com/"
  url "http://tjaberg.com/gsar121.zip"
  version "1.21"
  sha256 "05fb9583c970aba4eb0ffae2763d7482b0697c65fda1632a247a0153d7db65a9"

  bottle :unneeded

  def install
    system "make"
    bin.install "gsar"
  end

  test do
    assert_match /1 occurrence changed/, shell_output("#{bin}/gsar -sCourier -rMonaco #{test_fixtures("test.ps")} new.ps")
  end
end
