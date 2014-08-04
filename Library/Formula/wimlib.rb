require "formula"

class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.7.0.tar.gz"
  sha1 "7f9bdd44a11f04e1550286b574579f48e2584d5a"

  bottle do
    cellar :any
    sha1 "af34c91321fdaaaa256b4dea0082df8be73e8fd7" => :mavericks
    sha1 "9ea8ca5bb46f8ef3f46e1ca4db544274b94b9582" => :mountain_lion
    sha1 "664ed90aafc7efb9d175c71078f9fa94a3a9b841" => :lion
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
