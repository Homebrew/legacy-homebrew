require "formula"

class LSmash < Formula
  homepage "http://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.11.7", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "8e76e28f5f8727e19e872ef410569e42b720468d" => :mavericks
    sha1 "dc3a85de0c338dfebdc68e69ea5957639103c797" => :mountain_lion
    sha1 "e112033ac79be6aedf04a25cd76d4b815253d5a6" => :lion
  end

  def install
    args = ["--prefix=#{prefix}", "--enable-shared"]

    # For getting version information correctly in the configure
    buildpath.install_symlink cached_download/".git"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/boxdumper", "-v"
    system "#{bin}/muxer", "-v"
    system "#{bin}/remuxer", "-v"
    system "#{bin}/timelineeditor", "-v"
  end
end
