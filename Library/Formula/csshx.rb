class Csshx < Formula
  desc "Cluster ssh tool for Terminal.app"
  homepage "https://github.com/brockgr/csshx"
  url "https://csshx.googlecode.com/files/csshX-0.74.tgz"
  mirror "https://distfiles.macports.org/csshX/csshX-0.74.tgz"
  sha256 "eaa9e52727c8b28dedc87398ed33ffa2340d6d0f3ea9d261749c715cb7a0e9c8"

  head "https://github.com/brockgr/csshx.git"

  def install
    bin.install "csshX"
  end
end
