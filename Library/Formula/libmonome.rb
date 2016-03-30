class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "http://illest.net/libmonome/"
  url "https://github.com/monome/libmonome/releases/download/v1.4.0/libmonome-1.4.0.tar.bz2"
  sha256 "0a04ae4b882ea290f3578bcba8e181c7a3b333b35b3c2410407126d5418d149a"

  head "https://github.com/monome/libmonome.git"

  bottle do
    revision 1
    sha256 "ea162837907418169e25792d8da975bf6d0d5be0c8cae54d10c743f5a720db31" => :yosemite
    sha256 "4afd09ca96908afab0fa3ac91ed96ac70b7b7119a07a4dcfb106617f845e0586" => :mavericks
    sha256 "238d0fd9c275ad66972a2dc784ec78926ec13a14b58acd9fd102a90b16cf265f" => :mountain_lion
  end

  depends_on "liblo"

  def install
    inreplace "wscript", "-Werror", ""
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
