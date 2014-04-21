require "formula"

class Subnetcalc < Formula
  homepage "http://www.iem.uni-due.de/~dreibh/subnetcalc/"
  url "http://www.iem.uni-due.de/~dreibh/subnetcalc/download/subnetcalc-2.2.0.tar.gz"
  sha1 "fbe6411443f4140937a85f051e733efd803ec7b3"

  depends_on 'geoip' => :recommended

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-geoip=no" if build.without? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
