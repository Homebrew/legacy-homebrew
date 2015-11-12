class Flickcurl < Formula
  desc "Library for the Flickr API"
  homepage "http://librdf.org/flickcurl/"
  url "http://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz"
  sha256 "ff42a36c7c1c7d368246f6bc9b7d792ed298348e5f0f5d432e49f6803562f5a3"

  bottle do
    cellar :any
    sha1 "6f621c0db12c69bb0337be2740e50d5f3d080c5f" => :yosemite
    sha1 "50deb6a9aaf2a9c8e33fabe1521040bf29d785ec" => :mavericks
    sha1 "5f5f52bf4a49d267b70ddbe53e58017056c0338a" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/flickcurl -h 2>&1", 1)
    assert output.include? "flickcurl: Configuration file"
  end
end
