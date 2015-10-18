class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "http://webonastick.com/vtclock/"
  url "http://webonastick.com/vtclock/vtclock-2005-02-20.tar.gz"
  sha256 "5fcbceff1cba40c57213fa5853c4574895755608eaf7248b6cc2f061133dab68"

  version "2005-02-20"

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock -h"
  end
end
