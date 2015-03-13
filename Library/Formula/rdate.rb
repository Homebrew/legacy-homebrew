class Rdate < Formula
  homepage "http://www.aelius.com/njh/rdate/"
  url "http://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rdate", "-p", "-t", "2", "0.pool.ntp.org"
  end
end
