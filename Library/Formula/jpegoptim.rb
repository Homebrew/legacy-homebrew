class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.2.tar.gz"
  sha1 "7eb558f2fa240d6ef2f8476aa8ea51f7903666ad"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha1 "8c4bdc923d599e73c00e515354cac08e345a640a" => :yosemite
    sha1 "0594a4efa134faa6e731349ad0a4eb26d1e07910" => :mavericks
    sha1 "9bac06c05cc397f80f576db119b7dc89337b46ab" => :mountain_lion
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match(/OK/, shell_output("#{bin}/jpegoptim --noaction #{source}"))
  end
end
