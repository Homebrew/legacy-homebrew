require "formula"

class Wipe < Formula
  homepage 'http://lambda-diode.com/software/wipe/'
  url 'https://github.com/locolupo/wipe/archive/0.23.tar.gz'
  sha1 '3abd8182e37ecf2a4e9fda7a0c88ba98b99ee5ae'

  def install
    system "make", "macos"
    bin.install "wipe"
  end
end
