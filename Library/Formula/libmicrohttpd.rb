require "formula"

class Libmicrohttpd < Formula
  homepage "http://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.38.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.38.tar.gz"
  sha1 "1d0a6685b984b022a6be565f7b179c449944b3f1"

  bottle do
    cellar :any
    revision 1
    sha1 "aacdc62a4d475d531ab371789827467606374d53" => :yosemite
    sha1 "244043f22a39f88c07cfaa3d95088118dad1b73f" => :mavericks
    sha1 "26bb4de80f5d43bfb24685f651467fd97d821936" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
