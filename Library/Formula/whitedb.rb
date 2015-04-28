class Whitedb < Formula
  homepage "http://whitedb.org/"
  url "http://whitedb.org/whitedb-0.7.3.tar.gz"
  sha256 "10c4ccd754ed2d53dbdef9ec16c88c732aa73d923fc0ee114e7e3a78a812849d"

  depends_on "python" => :optional

  def install
    # https://github.com/priitj/whitedb/issues/15
    ENV.append "CFLAGS", "-std=gnu89"

    args = ["--prefix=#{prefix}"]
    args << "--with-python" if build.with? "python"
    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wgdb", "create", "512k"
    system "#{bin}/wgdb", "add", "42"
    system "#{bin}/wgdb", "select", "1"
    system "#{bin}/wgdb", "free"
  end
end
