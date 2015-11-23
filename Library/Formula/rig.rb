class Rig < Formula
  desc "Provides fake name and address data"
  homepage "http://rig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha256 "00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8"

  def install
    system "make"
    bin.install "rig"
    (share/"rig").install Dir["data/*"]
  end

  test do
    system "#{bin}/rig"
  end
end
