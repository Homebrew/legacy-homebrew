class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.6.3",
                                                  :revision => "cd6d4237d77c22559a8f6dc92c09ef297be91ea5",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha256 "318dbf4bbbb8d93fa99676f0e3e6708e515ebb97c345a317a79869307dd94eae" => :yosemite
    sha256 "51db791570ab0afd405f30ea2980e1af4e75403d3616cf37e54e40dc2fb68b14" => :mavericks
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
