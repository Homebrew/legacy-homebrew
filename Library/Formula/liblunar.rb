class Liblunar < Formula
  desc "Lunar date calendar"
  homepage "https://code.google.com/p/liblunar/"
  url "https://liblunar.googlecode.com/files/liblunar-2.2.5.tar.gz"
  sha256 "c24a7cd3ccbf7ab739d752a437f1879f62b975b95abcf9eb9e1dd623982bc167"

  bottle do
    revision 1
    sha1 "8113fe85f888c12a9841aa6281016406ec7b9799" => :yosemite
    sha1 "b92965d3651332b69eb42a1f6341b5daf12b9632" => :mavericks
    sha1 "69b6824161e90b0578e314efcae5db056930ed2e" => :mountain_lion
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
