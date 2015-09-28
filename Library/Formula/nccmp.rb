class Nccmp < Formula
  desc "nccmp compares 2 NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/projects/nccmp/files/nccmp-1.7.4.0.tar.gz"
  sha256 "7760b65e54f6b07ee764fe37a71eaa1710f4c6440c6fa5ee05796912865748fb"

  depends_on 'netcdf'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "true"
  end
end
