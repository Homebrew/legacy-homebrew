class MysqldumpSecure < Formula
  desc "Encrypted mysqldump with compression, logging and Nagios integration."
  homepage "https://github.com/cytopia/mysqldump-secure"
  url "https://github.com/cytopia/mysqldump-secure/archive/0.11.3.tar.gz"
  sha256 "046eb5da52d17f0a22d24a53380d820ce50dcff21b55047549ac61366fbc16a1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "reinstall"
  end
  
  test do
    system bin/"mysqldump-secure 2>&1 | grep ''"
  end

end
