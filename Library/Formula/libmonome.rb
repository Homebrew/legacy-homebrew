class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "http://illest.net/libmonome/"
  url "https://github.com/monome/libmonome/archive/1.2.tar.gz"
  sha256 "c4af0d1e029049e35e0afff148109f41f839afd7cbcd431a2632585e80c57190"

  head "https://github.com/monome/libmonome.git"

  bottle do
    revision 1
    sha1 "c0b250665b0c97d68575ff9aed7e74249be1661e" => :yosemite
    sha1 "71804657209d9292adbe3215cd44d9ce9894eb87" => :mavericks
    sha1 "0ef839a2f1d96cd546d9aef7d7eaafba1ce39668" => :mountain_lion
  end

  depends_on "liblo"

  def install
    inreplace "wscript", "-Werror", ""
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
