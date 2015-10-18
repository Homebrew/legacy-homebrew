class Imagejs < Formula
  desc "Tool to hide JavaScript inside valid image files"
  homepage "http://jklmnn.de/imagejs/"
  url "https://github.com/jklmnn/imagejs/archive/0.7.1.tar.gz"
  sha256 "d1a1368ce72a1a7d18d053f82bf19c7af14861588a459f3bf69f2b50a335633f"
  head "https://github.com/jklmnn/imagejs.git"

  bottle do
    cellar :any
    sha1 "d5a3f3c28b1e5510fc106a0070f4ba5a136ed67f" => :yosemite
    sha1 "18f653871caf008d21292f12c43a5592e64e7816" => :mavericks
    sha1 "5a65ab6f7a32e27c4908f33c46c150545317dbc7" => :mountain_lion
  end

  def install
    system "make"
    bin.install "imagejs"
  end

  test do
    (testpath/"test.js").write "alert('Hello World!')"
    system "#{bin}/imagejs", "bmp", "test.js", "-l"
  end
end
