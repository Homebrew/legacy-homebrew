class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.7.tar.gz"
  sha256 "4ed165aa2203136dce548c7cef735d8becf5d9869793f96b99dcbbaa9acf78d8"

  bottle do
    cellar :any
    revision 2
    sha256 "fbad262bc1c5ebea09031d33d1c67efedee1a24b3b6fe36f18b1f74a86ad1304" => :el_capitan
    sha256 "d2fae18378a7d83f0e4f0068f07afa6cdc54a8a25f2aa84990cf1a5a18e9788f" => :yosemite
    sha256 "9d0b9a844dbeeb8d5ef58710d0dac485af94a9dc010edc585a9e73464a12e596" => :mavericks
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
