class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook"
  url "https://njw.name/getxbook/getxbook-1.2.tar.xz"
  sha256 "7a4b1636ecb6dace814b818d9ff6a68167799b81ac6fc4dca1485efd48cf1c46"

  bottle do
    cellar :any
    sha1 "ec68ebd4b467ad6c3ffbb90a64118f670cf07445" => :yosemite
    sha1 "6a7f366ad91c8cfc0bdf3f40892eb95734f7149a" => :mavericks
    sha1 "048a83fbd2e824e8ad77fa86a7c6a91fd69cb6a3" => :mountain_lion
  end

  option "with-gui", "Build the GUI"

  depends_on "openssl"
  depends_on "tcl-tk" if build.with? "gui"

  def install
    args = %W[CC=#{ENV.cc} PREFIX=#{prefix}]
    args << "install" if build.with?("gui")

    system "make", *args
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
