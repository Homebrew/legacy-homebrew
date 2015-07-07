require 'formula'

class Clockywock < Formula
  desc "Ncurses analog clock"
  homepage 'http://soomka.com/'
  url 'http://soomka.com/clockywock-0.3.1a.tar.gz'
  sha1 '6df4c4e6bc2c7f2f8bd3534b46da59b8a80b4e04'

  def install
    system "make"
    bin.install "clockywock"
    man7.install "clockywock.7"
  end

  test do
    system "#{bin}/clockywock -h"
  end
end
