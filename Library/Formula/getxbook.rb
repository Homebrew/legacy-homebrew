class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "http://njw.me.uk/software/getxbook/"
  url "http://njw.me.uk/software/getxbook/getxbook-1.1.tar.bz2"
  sha1 "9d47918ed77e8fb4f4e8b3c412cdcc82834be3e8"

  bottle do
    cellar :any
    sha1 "ec68ebd4b467ad6c3ffbb90a64118f670cf07445" => :yosemite
    sha1 "6a7f366ad91c8cfc0bdf3f40892eb95734f7149a" => :mavericks
    sha1 "048a83fbd2e824e8ad77fa86a7c6a91fd69cb6a3" => :mountain_lion
  end

  option "with-gui", "Build the GUI"

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
