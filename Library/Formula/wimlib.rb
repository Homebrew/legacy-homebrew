require "formula"

class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.7.0.tar.gz"
  sha1 "7f9bdd44a11f04e1550286b574579f48e2584d5a"

  bottle do
    cellar :any
    sha1 "5ded91da7bc581ef671d456c45598084a21d78dd" => :mavericks
    sha1 "cff1e472add1248fc751d6fa8f93034a2af8b197" => :mountain_lion
    sha1 "f7ed2dcc8efebe0702f188d3c0846392438b0c70" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "ntfs-3g"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-fuse", # requires librt, unavailable on OSX
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"wiminfo", "--help"
  end
end
