class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "http://www.aelius.com/njh/rdate/"
  url "http://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"

  bottle do
    cellar :any
    sha256 "d962e91795117120254eaf32a2aa2e8ece278878fc993e4b34af6f64c259fcf7" => :yosemite
    sha256 "8d6ddfab85875845287bedd1dc1db43f3f589d2e6987ca5a369bc228805818c4" => :mavericks
    sha256 "3cb827a2d8c308da387d6eff74c64e3ec4dc049e1960511ce14fe60a5f267c9c" => :mountain_lion
  end

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
