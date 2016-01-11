class Whitedb < Formula
  desc "Lightweight in-memory NoSQL database library"
  homepage "http://whitedb.org/"
  url "http://whitedb.org/whitedb-0.7.3.tar.gz"
  sha256 "10c4ccd754ed2d53dbdef9ec16c88c732aa73d923fc0ee114e7e3a78a812849d"

  bottle do
    cellar :any
    sha256 "0fa38dca524c08f51fa724fb49df5a3ebdde46a3251b2a282d5343b36c4c249f" => :yosemite
    sha256 "ba756975f0dbdfa4259a5a4271414765644b0abe8c771d0c091238909f0968d2" => :mavericks
    sha256 "aa86b2acca68b9999ecb4cb9da7c64f659a97ffbd50d7aeb78c021df13866474" => :mountain_lion
  end

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
