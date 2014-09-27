require "formula"

class Lightning < Formula
  homepage "http://www.gnu.org/software/lightning/"
  url "http://ftpmirror.gnu.org/lightning/lightning-2.0.5.tar.gz"
  mirror "http://ftp.gnu.org/gnu/lightning/lightning-2.0.5.tar.gz"
  sha1 "a3b7ba0697690f578bac1d4c991c8e3cbaa33aaf"

  bottle do
    cellar :any
    sha1 "8366a3a9ea733b4e5dea4bd17f343c124e4548a7" => :mavericks
    sha1 "292379bc8c63a7b286e5a682d5f19ea8c04880d5" => :mountain_lion
    sha1 "eb8db8f32ceddaddaf445bb45268d13d753f89ba" => :lion
  end

  def install
    system "./configure","--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
