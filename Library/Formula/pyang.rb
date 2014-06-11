require "formula"

class Pyang < Formula
  homepage "https://code.google.com/p/pyang/"
  url "https://pyang.googlecode.com/files/pyang-1.4.1.tar.gz"
  sha1 "70ce33fb0964c22f477d36a704898c9c35ad9a6b"

  head "http://pyang.googlecode.com/svn/trunk"

  depends_on :python

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/pyang -v"
  end
end
