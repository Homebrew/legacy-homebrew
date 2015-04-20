class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.6.4",
                                                  :revision => "fb67bc83840ca886c5b4a7fac069f08fba147431",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha256 "87c17787d448acc647be6df6f3599de1f76f8b8ae25630bb18e4f9a861b5d230" => :yosemite
    sha256 "017088d077c0d17a11e77e05fee9f4dfa6d862fadbf2aacd381bbc898c04da6a" => :mavericks
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
