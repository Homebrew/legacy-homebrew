class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.14",
                                                  :revision => "299880a5738f51d83be1def2d35304dea54c4850",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "bd2caab499f2b52337130c8c95b7601abb1baf2ddafdb3fd1808cf407c4e8b78" => :el_capitan
    sha256 "0e9935b1a249deacd00c7338c1f005437d08e18e45204b36d623d7fe265cac0e" => :yosemite
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
