require 'formula'

class Analog < Formula
  homepage 'http://analog.cx'
  url 'http://analog.cx/analog-6.0.tar.gz'
  sha1 '17ad601f84e73c940883fb9b9e805879aac37493'
  revision 1

  bottle do
    sha1 "f8f9b2a12923d2702c6f9403d51ed2730bd6fef8" => :mavericks
    sha1 "6bb59edcf53fa011463cbdc531df9c9f1b9698f1" => :mountain_lion
    sha1 "968ff8fcb3851697ad7d6f680accc7860cefee55" => :lion
  end

  depends_on 'gd'
  depends_on 'jpeg'
  depends_on 'libpng'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DEFS='-DLANGDIR=\"#{share/'analog/lang/'}\"' -DHAVE_ZLIB",
                   "LIBS=-lz",
                   "OS=OSX"
    bin.install "analog"
    (share/'analog').install "examples", "how-to", "images", "lang"
    (share/'analog').install "analog.cfg" => "analog.cfg-dist"
    man1.install "analog.man" => "analog.1"
  end

  test do
    system "\"#{bin}/analog\" > /dev/null"
  end
end
