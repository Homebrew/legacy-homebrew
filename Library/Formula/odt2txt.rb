class Odt2txt < Formula
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
  end

  bottle do
    cellar :any
    sha1 "21e4d5f82d941a5ba13f191b6c4011aa456b5c7e" => :yosemite
    sha1 "0bc3eb54110df5ba74f18f0b89dfe6819e7e3b75" => :mavericks
    sha1 "064b2423089db500bf5d850f97b95e32bc947cab" => :mountain_lion
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
