class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://www.rfc1149.net/devel/recoverjpeg.html"
  url "https://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.3.tar.gz"
  sha256 "d6a63f0362c1f62ba9d022e044bf6cd404250547a921f25aa2d0087d08faf1ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "f36a76936a645367cd0d508709a9658a827188a7ceb818fc2af56ecf37946b56" => :el_capitan
    sha256 "0fc2ef04e6e9bb3f8bc2f2ce738a11970f426bab8c586c722cf1d8ee07d35766" => :yosemite
    sha256 "7c5d73b1e71d41dcae6c8d7fd25b40fbc4bcccc665b89eca5dab43185ad17e94" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
