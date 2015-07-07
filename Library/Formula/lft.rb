require "formula"

class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "http://pwhois.org/lft/"
  url "http://pwhois.org/dl/index.who?file=lft-3.73.tar.gz"
  sha1 "c5a37bef74d7466d5202ee8136acc3213711252e"

  bottle do
    cellar :any
    sha1 "ff1a651b0544691f535bd22199530ea4b53093ba" => :mavericks
    sha1 "9d04de7da326ee34f836f845bfbae9c6a7b18586" => :mountain_lion
    sha1 "9e3320656b5181236b9c24de6693de07f47290f8" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
