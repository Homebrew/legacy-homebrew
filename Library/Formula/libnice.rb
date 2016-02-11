class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.7.tar.gz"
  sha256 "4ed165aa2203136dce548c7cef735d8becf5d9869793f96b99dcbbaa9acf78d8"

  bottle do
    cellar :any
    revision 1
    sha256 "3a14bfa7c0252d38aeb166fce93f8baace5f3ed51728e432838fe2c0f4486746" => :yosemite
    sha256 "fb43d403aa966cb0dacd28e089a6b02ad376ff4b144393b33bc91f530909786b" => :mavericks
    sha256 "659391e379d1fe736cc95aff8414a2328cfb424bb9bd962eb35347257688dd3b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gstreamer"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
