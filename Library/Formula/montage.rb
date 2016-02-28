class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v4.0.tar.gz"
  sha256 "de143e4d4b65086f04bb75cf482dfa824965a5a402f3431f9bceb395033df5fe"

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
end
