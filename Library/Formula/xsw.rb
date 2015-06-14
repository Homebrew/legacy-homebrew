class Xsw < Formula
  desc "Slide show presentation tool"
  homepage "https://code.google.com/p/xsw/"
  url "https://xsw.googlecode.com/files/xsw-0.3.5.tar.gz"
  sha256 "d7f86047716d9c4d7b2d98543952d59ce871c7d11c63653f2e21a90bcd7a6085"

  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "sdl_image"
  depends_on "sdl_gfx"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xsw", "-v"
  end
end
