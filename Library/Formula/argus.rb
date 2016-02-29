class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-3.0.8.1.tar.gz"
  sha256 "1fb921104c8bd843fb9f5a1c32b57b20bfe8cd8a103b3f1d9bb686b9e6c490a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "422d8a3a75e0c6d4095200c38e33722721acd8826f2833e6fe2269a5dc307c92" => :el_capitan
    sha256 "7e369883e4ef8eda6efd19eb31ba83f619fc13b758e40ade9f199c696e9e37b5" => :yosemite
    sha256 "6f6b81839f5f6a23b3a0be14bea615dab821bbe8be7dbfae886871ad41590191" => :mavericks
    sha256 "10f68e1435d342133a0d0fbcfc878b9f01fd95fa2d83f0e3adff7fdfaa1f3185" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
