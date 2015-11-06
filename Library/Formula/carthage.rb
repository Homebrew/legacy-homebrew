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
    sha256 "538dbfb46af97c561845e9e11aa891eed68afb43b493ab8426cad4bfc271dd7b" => :yosemite
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
