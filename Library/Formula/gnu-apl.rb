require "formula"

class GnuApl < Formula
  homepage "http://www.gnu.org/software/apl/"
  url "http://ftpmirror.gnu.org/apl/apl-1.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/apl/apl-1.4.tar.gz"
  sha1 "ee5dab7f7c0f5d79c435a20f3ddcafbda85ac22e"

  bottle do
    sha1 "e067c7741c9f7e174f0a5f06d99e59fe5b6e930b" => :mavericks
  end

  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on :macos => :mavericks

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "dumb"
    system "#{bin}/apl", "--version"
  end
end
