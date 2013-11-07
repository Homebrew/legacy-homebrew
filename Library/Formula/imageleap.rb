require 'formula'

class Imageleap < Formula
  homepage 'https://github.com/daytonn/imageleap'
  url 'https://github.com/daytonn/imageleap/archive/v1.0.7.tar.gz'
  sha1 'b5dfa3fae32ebdb4019292eda99d07389a9ed328'

  def install
    system "PREFIX='#{prefix}'"
    system "make"
    system "make", "install"
  end

  test do
    system "imageleap"
  end
end
