require "formula"

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.5.3",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  depends_on :xcode => ["6.1.1", :build]

  bottle do
    cellar :any
    sha1 "7c6ec5815bea395b07da3561401763777d43c865" => :yosemite
    sha1 "a4835184d68bc59f3a30654f5c25ed88b6667c40" => :mavericks
  end

  def install
    # Carthage likes to do stuff with submodules itself so we need a "real"
    # git clone rather than letting it play with our cache.
    cp_r cached_download/".git", "."

    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
