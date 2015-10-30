class Osxutils < Formula
  desc "Suite of Mac OS command line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.8.2.tar.gz"
  sha256 "83714582cce83faceee6d539cf962e587557236d0f9b5963bd70e3bc7fbceceb"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any
    sha1 "b2b540572693c94922b19b7109fb337bc45ffddf" => :yosemite
    sha1 "1f29480eab579c4f97606aabe89d8b39c1c440dd" => :mavericks
    sha1 "a76a3906847c9bdfa934ee46c7bcdeee772f1c26" => :mountain_lion
  end

  conflicts_with "trash", :because => "both install a trash binary"
  conflicts_with "leptonica",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/trash"
  end
end
