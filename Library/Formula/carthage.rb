class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.7",
                                                  :revision => "d35be75cb69762630d120412e51201f23b3c14df",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.3", :build]

  bottle do
    cellar :any
    sha256 "4c72a1e4fb5407c8b50de7d84828f55bec23a05e3999eb4d1049e9a37b23ef95" => :yosemite
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
