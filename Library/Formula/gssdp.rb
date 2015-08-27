class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/0.14/gssdp-0.14.8.tar.xz"
  sha256 "4c3ffa01435e84dc31c954e669e1ca0749b962f76a333e74f5c2cb0de5803a13"

  bottle do
    cellar :any
    sha1 "2d61f1ef839f57ec549e87de2acc36b48318a8c3" => :yosemite
    sha1 "27dd96f9c1b0aa935258d7c4588b11ccb8c8e019" => :mavericks
    sha1 "dfa1262a9f6ef41385b0c3e755afef69a2cbe55f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
