require "formula"

class Libtasn1 < Formula
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-4.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.0.tar.gz"
  sha1 "2187d9b9bfc6b3d15264ca4127e6f53415b87ca8"

  bottle do
    cellar :any
    sha1 "92e2fbe3e8b958a82567389014198d0eb93319a9" => :mavericks
    sha1 "0dfa2f426a87db64334d86551a53ce09fa8fe3d3" => :mountain_lion
    sha1 "1552dc3c56ab8ef245becc398c3a043fb15914ab" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
