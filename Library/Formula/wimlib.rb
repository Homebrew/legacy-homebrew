require "formula"

class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.7.3.tar.gz"
  sha1 "3e6633b932dec774fa348511efb1ec505159a481"

  bottle do
    cellar :any
    sha1 "9834abd0fc78c5b6f75a9eef98414fd8084750e3" => :mavericks
    sha1 "864775795fc1f13367752c9c9d997c2362c54bcb" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "ntfs-3g"
  depends_on "openssl"

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
