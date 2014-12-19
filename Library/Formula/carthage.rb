require "formula"

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.3.1",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

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
