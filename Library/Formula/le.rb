class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.15.1.tar.xz"
  sha256 "d9895ef82c89ae9cf30946bd43fa18b294f645e6a2bacd3ed9d39a3ccf324a4f"

  bottle do
    sha256 "895ac3308015381bbc23de9000df04c60f030eba9893fc2a5d036ff7d2c91355" => :yosemite
    sha256 "4118ed76a761d851a05a2886da41a984175ad25938ab0e91f878d405fbc19618" => :mavericks
    sha256 "696ba6e3163b72f35825f7f17b1c11cacf044efda4b6fbf14324f7c5688178d1" => :mountain_lion
  end

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
