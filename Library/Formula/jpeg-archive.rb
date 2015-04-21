require "formula"

class JpegArchive < Formula
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/2.1.1.tar.gz"
  sha1 "874846fdc3a44811cccec6415ddf4d46c0fcd568"

  depends_on "mozjpeg"

  def install
    system "make"
    bin.install "jpeg-archive", "jpeg-recompress", 'jpeg-hash', 'jpeg-compare'
  end

  test do
    system "#{bin}/jpeg-recompress",
           "/System/Library/CoreServices/DefaultDesktop.jpg",
           "output.jpg"
  end
end
