class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.7.4.1.tar.gz"
  sha256 "985b50505dd7517710c5699cb9ee1028c6d75b06a17649bb911d838c4908dc69"

  depends_on "netcdf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cdl").write("netcdf {}")
    system "ncgen", "-o", testpath/"test1.nc", testpath/"test.cdl"
    system "ncgen", "-o", testpath/"test2.nc", testpath/"test.cdl"
    system "#{bin}/nccmp", "-mds", testpath/"test1.nc", testpath/"test2.nc"
  end
end
