require "formula"

class Wipe < Formula
  version '0.23'
  homepage 'http://lambda-diode.com/software/wipe/'
  url 'https://github.com/locolupo/wipe/archive/master.tar.gz'
  sha1 'd99a9a448d4911813909c8e0d9fddf448f6b427c'

  def install
    system "make", "macos"
    bin.install "wipe"
  end
end
