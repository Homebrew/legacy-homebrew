class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.7.3",
                                                  :revision => "ad8fba1a091ae493281ab44953f1e8ca4e6c0405",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.3", :build]

  bottle do
    cellar :any
    sha256 "3569536f409798e97fc0321e30e0d1ccd7a9bd503d939fc1ebab03e8cfd0e39a" => :yosemite
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
