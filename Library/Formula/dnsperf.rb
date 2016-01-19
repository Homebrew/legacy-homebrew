class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://nominum.com/measurement-tools/"
  url "ftp://ftp.nominum.com/pub/nominum/dnsperf/2.0.0.0/dnsperf-src-2.0.0.0-1.tar.gz"
  sha256 "23d486493f04554d11fca97552e860028f18c5ed6e35348e480a7448fa8cfaad"

  bottle do
    cellar :any
    sha256 "e169ef157bfb88e0161f7c14f2ab7752138175f93c2f05c7e0d00d9afd696f06" => :el_capitan
    sha256 "54cdcb0c2c6e150031b2ce436494a5a218828058ad37a087203165eb6a24ce4e" => :yosemite
    sha256 "dc94a7815272721dc7a9d89fbdd133122a5002bb6b9dc84417acd6ec19f1a636" => :mavericks
  end

  depends_on "bind"
  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
