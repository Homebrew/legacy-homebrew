class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.0/libass-0.13.0.tar.gz"
  sha256 "67692ef2a56e0423d22b142edb072c04949fe88c37be1d19cf22669c44f935f3"

  bottle do
    cellar :any
    sha256 "cf1af3bd7ddb8138afe2d404897d48a4c78d5b2518ffef7d8785fcaa09144113" => :el_capitan
    sha256 "cf0373b3f9d85cd4db27f37ea1cdc34a18033b5f5ce966d391165a1dcffc9e48" => :yosemite
    sha256 "7303bf3c119bc80d850f8e16ac1212e70224c83df3f8a3c0bf2adb0d378a6e80" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz" => :recommended

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
