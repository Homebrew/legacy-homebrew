class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.8/gphoto2-2.5.8.tar.bz2"
  sha256 "a9abcd15d95f205318d17e3ac12af7ce523d2bc4943709d50b0a12c30cc5ee4d"

  bottle do
    cellar :any
    sha1 "49afbd5764c72ab04513f1db5556f6d44f94cb3d" => :yosemite
    sha1 "ffa581599c7e9097052de4e5c974c965d41e8435" => :mavericks
    sha1 "a898338454285c9ab1d01f4b55e464701a403faf" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
