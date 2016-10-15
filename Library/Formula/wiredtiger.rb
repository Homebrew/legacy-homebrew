class Wiredtiger < Formula
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.4.1/wiredtiger-2.4.1.tar.bz2"
  sha1 "3500e044fa845c15395ff9dfb5e805755d15b4a4"
  depends_on "snappy"

  def install
    system "./configure", "--with-builtins=snappy,zlib",
                          "--with-python",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "wt", "create", "table:test"
    system "wt", "drop", "table:test"
  end
end
