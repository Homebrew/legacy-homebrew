class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "http://www.caida.org/tools/measurement/scamper/"
  url "http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141211a.tar.gz"
  sha256 "1073d4889abd9d4ec0d8f988921b6ad4f3535030cf007abb99e67f9e6b2052b8"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
