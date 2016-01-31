class MysqldumpSecure < Formula
  desc "Encrypted mysqldump with compression, logging, blacklisting and Nagios/Icinga monitoring integration"
  homepage "https://github.com/cytopia/mysqldump-secure"
  url "https://github.com/cytopia/mysqldump-secure/archive/0.11.3.tar.gz"
  version "0.11.3"
  sha256 "046eb5da52d17f0a22d24a53380d820ce50dcff21b55047549ac61366fbc16a1"

  def install
	#ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
	system "make"
    system "make", "reinstall"
  end

end
