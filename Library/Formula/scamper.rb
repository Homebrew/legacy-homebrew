class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141211a.tar.gz"
  sha256 "1073d4889abd9d4ec0d8f988921b6ad4f3535030cf007abb99e67f9e6b2052b8"

  bottle do
    cellar :any
    sha256 "d07d1e41c4d9f2c7dac1861e695b2bda63fe9d12c8f710383f3b4337112c70cf" => :yosemite
    sha256 "ee6317d956817966ae7ecb04cba1432c238b4e0450df9471b4d9b50a28b1591d" => :mavericks
    sha256 "c0eaa62c685890f9943148d259b5dcffdc9c988afd96e577e2eb5cfa17aee220" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
