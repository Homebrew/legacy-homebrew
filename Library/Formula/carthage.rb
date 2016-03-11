class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.15.1",
                                                  :revision => "e7c54b68994a3904a55dc530d22a1ac3a87c1182",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "f0d14960621fc28712fbee016ddc7851adf72f06ff8ce61919cdea987c85e2f7" => :el_capitan
    sha256 "2b998dc2b8c5913d579b0a134be93e19b37a16d410463fc0c7168d358c8fe18d" => :yosemite
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
