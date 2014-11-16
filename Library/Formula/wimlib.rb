require "formula"

class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.7.1.tar.gz"
  sha1 "ffbd2f138b396b0f1fb684294747d9c8b5421188"

  bottle do
    cellar :any
    revision 1
    sha1 "f3771fc90479055608bf752f8c9884169aa63969" => :yosemite
    sha1 "78db53c2dc541e8d784a56acf3ea45e52f1cd2b9" => :mavericks
    sha1 "afeba655f906d59e9afc8acec3fd105a39d9e221" => :mountain_lion
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
