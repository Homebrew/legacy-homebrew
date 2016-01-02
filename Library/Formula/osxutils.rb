class Osxutils < Formula
  desc "Suite of Mac OS command line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.8.2.tar.gz"
  sha256 "83714582cce83faceee6d539cf962e587557236d0f9b5963bd70e3bc7fbceceb"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a3039916a2cc607a98f5d4576b534e341f7823b7b16bdcfa66fca487379f366" => :el_capitan
    sha256 "86cee8409262fdda5d6634a86a29fe2d0fcee537baa8c9696de3a8abd27c2aa8" => :yosemite
    sha256 "91808d79c75537c563ee9a36b45e21703fcc4377d6c6ea7e7215f5ad9b0aa605" => :mavericks
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
