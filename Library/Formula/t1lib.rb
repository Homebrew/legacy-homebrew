class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "http://www.t1lib.org/"
  url "http://www.ibiblio.org/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"

  bottle do
    revision 1
    sha1 "d0e610a54eeaa0f6a5dfdbfe8a60b7d4a7bbd2c4" => :yosemite
    sha1 "480846a0795f75a04b0e86621afcc7e19352ca16" => :mavericks
    sha1 "e7ae71cb8f1080e9c8b5bc95468ff4dd0bc4c7d6" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end
end
