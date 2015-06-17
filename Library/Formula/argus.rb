require "formula"

class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-3.0.8.tar.gz"
  sha1 "fe9833c7f8ea4cdf7054b37024e5d007613f9571"

  bottle do
    cellar :any
    sha1 "5b8ca09efc8f4f84d78883f3f866628da061928b" => :yosemite
    sha1 "c96587d47409a7cb961450ade0b76558c1bf3f9c" => :mavericks
    sha1 "13a6e2c690d830adddb45bce4b8b0b24a01c9249" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
