class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.13",
                                                  :revision => "b34ffca97ddae86508714ab0ae5475c33be1afc4",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "636318d67fef17fb7df097e47bdfb22bb973168a5f43694635fc5ec37d27a042" => :el_capitan
    sha256 "53967c556f7afc2a7966dee444deb7588e65dc414f92384d0e43ac94986c4430" => :yosemite
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
