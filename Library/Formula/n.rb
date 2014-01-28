require 'formula'

class N < Formula
  homepage 'https://github.com/visionmedia/n'
  head 'https://github.com/visionmedia/n.git'
  url 'https://github.com/visionmedia/n/archive/1.1.0.tar.gz'
  sha1 '93c7661630310ca38627052be4df47f89285b099'

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
