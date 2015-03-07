class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.6.2",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha1 "dde8190c8b66184fd85111b739039aefb5d050a9" => :yosemite
    sha1 "b663dcf2608c97c7542121eb1a011ca7d0df70cd" => :mavericks
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
