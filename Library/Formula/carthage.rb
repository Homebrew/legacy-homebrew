require "formula"

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.5.1",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha1 "5699c2e96488ebf0216901e1da096c5e29c578ed" => :yosemite
    sha1 "9370a19dfa06a9416c42fc212c4ca94ba0f1e64b" => :mavericks
  end

  def install
    # Carthage likes to do stuff with submodules itself so we need a "real"
    # git clone rather than letting it play with our cache.
    cp_r cached_download/".git", "."

    system "make", "prefix_install", "PREFIX=#{prefix}"

    # Carthage puts some stuff in /tmp so clean it up after we're done.
    system "make", "clean"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
