require "formula"

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.5",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha1 "38a4e1a2409e009c77b1cc2e6697c91102461a64" => :yosemite
    sha1 "1ac83c143cc366ee81c2a810b2fbb0206967a513" => :mavericks
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
