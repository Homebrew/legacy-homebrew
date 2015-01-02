require "formula"

class Ktoblzcheck < Formula
  homepage "http://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.48.tar.gz"
  sha1 "80d1a586e2d581dce62094fed61b9292f2c72c6b"

  bottle do
    sha1 "7190e0fde6f0cbeb76b28981a7a6c497ed766455" => :mavericks
    sha1 "fcb5cb779e4a70797fc979a99bb9a3a6305607f4" => :mountain_lion
    sha1 "0627b12d557570f55d8c9d944199c08406d70732" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
