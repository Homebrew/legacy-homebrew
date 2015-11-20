class Osxutils < Formula
  desc "CLI access of Mac-specific information, settings, and metadata"
  homepage "https://github.com/vasi/osxutils"
  url "https://github.com/vasi/osxutils/archive/v1.8.1.tar.gz"
  sha256 "26c49f00435d2b58a3768f0712d25afc09139e91994ba2bdaa21915004214186"
  head "https://github.com/vasi/osxutils.git"

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
