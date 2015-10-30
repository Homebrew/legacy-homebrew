class Osxutils < Formula
  desc "Suite of Mac OS command line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.8.2.tar.gz"
  sha256 "83714582cce83faceee6d539cf962e587557236d0f9b5963bd70e3bc7fbceceb"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any
    sha256 "0154957f7c9be66a35f4e14362ba0c35d432c76b5ce816f9f1ad2d423be9f0b6" => :yosemite
    sha256 "a979cdf2c1512375431b9861bc743bf4f39ae809605ebfa124c852a0799c8618" => :mavericks
    sha256 "ed8b660943ff437f3efb94bd906ea0dff7bd3be795af3fc0107f9578f8f99a0d" => :mountain_lion
  end

  conflicts_with "trash", :because => "both install a trash binary"
  conflicts_with "leptonica",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."
  conflicts_with "wiki", :because => "both install `wiki` binaries"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/trash"
  end
end
