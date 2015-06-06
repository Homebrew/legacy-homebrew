class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.7.4-homebrew",
                                                  :revision => "199d3b3dfd5a5ce7aeb919eb9206b7faf1374e20",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.3", :build]

  bottle do
    cellar :any
    sha256 "64436bc00d57bdb6a814abf96db950cb34fc1c04a4d923204c802aa79e5bce78" => :yosemite
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
