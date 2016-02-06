class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.13",
                                                  :revision => "b34ffca97ddae86508714ab0ae5475c33be1afc4",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "7326aefe3c41e9b2a6ce0ba76292e3ac1d64be4ecd2d4881f67fdef34b272700" => :el_capitan
    sha256 "bf640cab958663bbf03d6f2e803d70b0f8e45bf2759397c38c0929095afa9a94" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
