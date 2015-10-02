class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "http://downloads.openfabrics.org/downloads/ofi/libfabric-1.1.1.tar.bz2"
  sha256 "228c50d1f9595009a026bb2293f372a04d89ecb3b0f7fcde3905476dbf49fc95"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
