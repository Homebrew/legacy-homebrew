class Flickcurl < Formula
  desc "Library for the Flickr API"
  homepage "http://librdf.org/flickcurl/"
  url "http://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz"
  sha256 "ff42a36c7c1c7d368246f6bc9b7d792ed298348e5f0f5d432e49f6803562f5a3"

  bottle do
    cellar :any
    sha256 "01886ddb800167eed18495d780baa81bac793243a54d452ad9a34a06e876e4d2" => :el_capitan
    sha256 "64c7a8f7d2bcc90063f926724fd1bd9277f783f3aca3c83e53684222f3d1d1c3" => :yosemite
    sha256 "e6950b0011dce7207b3ae5c7d42a7cce71c6d6c6a35461d2f8a5423be6415184" => :mavericks
    sha256 "918628ce806ec1517ee7f82c2d530f21a1ebeb4d3e8b0807def523256057b913" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/flickcurl -h 2>&1", 1)
    assert_match "flickcurl: Configuration file", output
  end
end
