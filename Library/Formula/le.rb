class Le < Formula
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.15.1.tar.xz"
  sha256 "d9895ef82c89ae9cf30946bd43fa18b294f645e6a2bacd3ed9d39a3ccf324a4f"

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
