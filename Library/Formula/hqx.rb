class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://code.google.com/p/hqx/"
  url "https://hqx.googlecode.com/files/hqx-1.1.tar.gz"
  sha256 "cc18f571fb4bc325317892e39ecd5711c4901831926bc93296de9ebb7b2f317b"

  depends_on "devil"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
