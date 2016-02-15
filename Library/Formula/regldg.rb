class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "http://regldg.com"
  url "http://regldg.com/regldg-1.0.0.tar.gz"
  sha256 "cd550592cc7a2f29f5882dcd9cf892875dd4e84840d8fe87133df9814c8003f1"

  def install
    system "make"
    bin.install "regldg"
  end

  test do
    system "#{bin}/regldg", "test"
  end
end
