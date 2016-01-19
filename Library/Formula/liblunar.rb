class Liblunar < Formula
  desc "Lunar date calendar"
  homepage "https://code.google.com/p/liblunar/"
  url "https://liblunar.googlecode.com/files/liblunar-2.2.5.tar.gz"
  sha256 "c24a7cd3ccbf7ab739d752a437f1879f62b975b95abcf9eb9e1dd623982bc167"

  bottle do
    revision 1
    sha256 "0964777ae7bbc24c64cab3a1197b5dfa123a08d7e320b4829b9f0a3d1a3cb6be" => :yosemite
    sha256 "9c4abb431abb5c60d1a9beba72f8139255f64d19a02e1994345531c948c72c3d" => :mavericks
    sha256 "66a40eb29dedc1cecc5947e5837e221a233273b130361eecb3488d51eede35be" => :mountain_lion
  end

  option "python", "Build python bindings using pygobject"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "vala" => :optional
  depends_on :python => :optional
  depends_on "pygobject" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-python" if build.without? "python"
    system "./configure", *args
    system "make", "install"
  end
end
