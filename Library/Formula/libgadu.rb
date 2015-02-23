class Libgadu < Formula
  homepage "http://libgadu.net/"
  url "http://github.com/wojtekka/libgadu/releases/download/1.12.1/libgadu-1.12.1.tar.gz"
  sha1 "a41435c0ae5dd5e7e3b998915639a8288398f86e"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
