class Negfix8 < Formula
  desc "Turn scanned negative images into positives"
  homepage "https://sites.google.com/site/negfix"
  url "https://sites.google.com/site/negfix/downloads/negfix8.3.tgz"
  sha256 "2f360b0dd16ca986fbaebf5873ee55044cae591546b573bb17797cbf569515bd"

  bottle :unneeded

  depends_on "imagemagick" => "with-quantum-depth-16"

  def install
    bin.install "negfix8"
  end

  test do
    (testpath/".negfix8/frameprofile").write "1 1 1 1 1 1 1"
    system "#{bin}/negfix8", "-u", "frameprofile", test_fixtures("test.tiff"),
        "#{testpath}/output.tiff"
    assert (testpath/"output.tiff").exist?
  end
end
