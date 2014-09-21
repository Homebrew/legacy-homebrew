require "formula"

class Grsync < Formula
  homepage "http://sourceforge.net/projects/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.5.tar.gz"
  sha256 "4f1443154f7c85ca7b0e93d5fea438e2709776005e7cfc97da89f4899b1c12e5"

  bottle do
    sha1 "da7610410092af265131c3b698d625a8c5f4b0fd" => :mavericks
    sha1 "4629045d73186a86cb950b6a528a97649696e3ed" => :mountain_lion
    sha1 "c957fd774c614e707bc06b1ce2122c3b13f4aa6b" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
