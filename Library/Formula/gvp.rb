class Gvp < Formula
  desc "Go versioning packager"
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.2.0.tar.gz"
  sha256 "ede10a32889cf284eaa4c4a9ed4e6bc0a85e0663246bf2fb7c1cf3965db661ea"

  bottle do
    cellar :any
    sha1 "f1b92b589cc6d28f1287e469ba07e49c9b7a2bac" => :yosemite
    sha1 "76979a476e5590b59cd063845810ab6dd5a01ab4" => :mavericks
    sha1 "ca229e3f90bf71121eb70112a52ffa0865a3ee5c" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gvp", "init"
    assert File.directory? ".godeps/src"
  end
end
