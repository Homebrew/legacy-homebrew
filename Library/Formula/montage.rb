class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v4.0.tar.gz"
  sha256 "de143e4d4b65086f04bb75cf482dfa824965a5a402f3431f9bceb395033df5fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "503c3e946aa0d8f277b5e4a5aab75086d5c895551fa679a3129183b95f89b236" => :el_capitan
    sha256 "7f9bb66eff925f20099f11ee247e4ba4c8b4821b74c7f2a3efd93d474e9a1b3f" => :yosemite
    sha256 "30e68dcecc111af10a65b1edd33a0142457b2f2064e1bce45e33a6d3d11539d4" => :mavericks
  end

  def install
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats; <<-EOS.undent
    Montage is under the Caltech/JPL non-exclusive, non-commercial software
    licence agreement available at:
      http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end
