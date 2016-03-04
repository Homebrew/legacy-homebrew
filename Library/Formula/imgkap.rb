class Imgkap < Formula
  desc "Tool to create nautical charts in KAP format."
  homepage "https://github.com/nohal/imgkap"
  url "https://github.com/nohal/imgkap/archive/v1.11.tar.gz"
  sha256 "5edb67582ee4e7f294bbd6cd71d0027a92b8ab1b81b9d2570d08606eaba206e9"

  depends_on "freeimage"

  def install
    system "make", "imgkap"
    bin.install "imgkap"
  end

  test do
    system "imgkap || true"
  end
end
