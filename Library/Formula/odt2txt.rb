class Odt2txt < Formula
  desc "Convert OpenDocument files to plain text"
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "dd54432a555e848fdb86e99cc4ad26b41e50ba52f045cd56056e630e6d83ac9b" => :yosemite
    sha256 "a24f4fdd461b5d25014b52abcfa4dcaba0504d60fba396582aa677af381349c3" => :mavericks
    sha256 "534b840b69bee074b4192d1d3c89a805f5647df4d9b12bddd0923bbdeedd8f9f" => :mountain_lion
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    resource("sample").stage do |r|
      system "odt2txt", r.cached_download
    end
  end
end
