require "formula"

class Ticcutils < Formula
  url "http://software.ticc.uvt.nl/ticcutils-0.5.tar.gz"
  homepage "http://ilk.uvt.nl/ticcutils/"
  sha1 "8cdd5aa1536bcf98ee4e48f188726ec826db90a0"

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

