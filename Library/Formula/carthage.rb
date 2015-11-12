class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.10",
                                                  :revision => "f27cc938b4b8bf9bdd20498c3cc0000346cd9c91",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["7.1", :build]

  bottle do
    cellar :any
    sha256 "95bcaad857704cd09b457ccb7ce41552851c9e3e0f1c5453660eecf25da70413" => :el_capitan
    sha256 "cf05d3ca3772349e26a7bf843f5eb2eaed1ddfd346967d092162a0794c55dcf0" => :yosemite
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
