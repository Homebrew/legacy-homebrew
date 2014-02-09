require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/2.0/capstone-2.0.tgz'
  sha1 '209cdc69518f754c5d7d07672d8e28cdda9feae7'

  def install
    system "./make.sh"
    ENV["PREFIX"] = prefix
    system "./make.sh", "install"
  end
end
