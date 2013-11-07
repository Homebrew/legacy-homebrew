require 'formula'

class Imageleap < Formula
  homepage 'https://github.com/daytonn/imageleap'
  url 'https://github.com/daytonn/imageleap/archive/v1.0.7.tar.gz'
  sha1 'b5dfa3fae32ebdb4019292eda99d07389a9ed328'

  def install
    system "make"
    system "make",  "PREFIX=#{prefix}", "install"
  end

  test do
    system "imageleap"
  end
end
