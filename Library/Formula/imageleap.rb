require 'formula'

class Imageleap < Formula
  homepage 'https://github.com/daytonn/imageleap'
  url 'https://github.com/daytonn/imageleap/archive/v1.0.6.tar.gz'
  sha1 'fa570157e205859208b3a2521d2b33e152cb4fc7'

  def install
    system "PREFIX='#{prefix}'"
    system "make"
    system "make", "install"
  end

  test do
    system "imageleap"
  end
end
