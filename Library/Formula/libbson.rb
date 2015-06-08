require "formula"

class Libbson < Formula
  desc "BSON utility library"
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.1.6/libbson-1.1.6.tar.gz"
  sha1 "0e4b74ad9e8848c3a5fa231de60e8bdaaf4fc3c7"

  bottle do
    cellar :any
    sha256 "04608ead2044c711fb374da28a18b5fe9e7983c4d1d4c4f4ba996ebc00abc10f" => :yosemite
    sha256 "0aa56dae1c07c75abb5604f9780c764c1791ee0ea45951a48d75702fb401fc86" => :mavericks
    sha256 "a50c21b0f1f641df27f22f41bcecfd2e77c37128accc0ae3a7f4501085204ae9" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
