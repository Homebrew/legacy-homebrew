require 'formula'

class Cfv < Formula
  url 'http://prdownloads.sourceforge.net/cfv/cfv-1.18.3.tar.gz'
  homepage 'http://cfv.sourceforge.net'
  sha256 'ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "make install"
  end
end
