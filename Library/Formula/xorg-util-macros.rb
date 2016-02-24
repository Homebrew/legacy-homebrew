class XorgUtilMacros < Formula
  desc "Miscellaneous utility macros required by the X.org codebase."
  homepage "http://www.x.org"
  url "http://xorg.freedesktop.org/archive/individual/util/util-macros-#{version}.tar.gz"
  version "1.19.0"
  sha256 "0d4df51b29023daf2f63aebf3ebc638ea88efedfd560ab5866741ab3f92acaa1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
