require "formula"

class Whitedb < Formula
  homepage "http://whitedb.org/"
  url "http://whitedb.org/whitedb-0.7.2.tar.gz"
  sha1 "055b6162e4c0eb225ab95347643fda583c0bbddd"

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
