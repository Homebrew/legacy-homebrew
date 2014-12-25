require "formula"

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.5",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha1 "a09cb5216f7a9f7978be190e323f8d093a0f275a" => :yosemite
    sha1 "754349bcd9a068611706ff6bdeea22b8f6ceb76c" => :mavericks
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
