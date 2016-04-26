class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.15.2",
                                                  :revision => "f811a275aaa06df53119bbfad42af754fb7b6ff7",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "f69638fb6e0abbb7d8b95ad83eba19aaac4112bbe21cad0a09876b30de894945" => :el_capitan
    sha256 "7411d6b369e1462f4c9b5da2aa17e9203e5e4168549328b2d8f8f7444ce5aeb4" => :yosemite
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
