require 'formula'

class Montage < Formula
  homepage 'http://montage.ipac.caltech.edu'
  url 'http://montage.ipac.caltech.edu/download/Montage_v3.3.tar.gz'
  sha1 'c8db5b9018c96e19b584d45758819e892b453d6d'

  def install
    system "make"
    bin.install Dir['bin/m*']
  end

  def caveats; <<-EOS.undent
    Montage is under the Caltech/JPL non-exclusive, non-commercial software
    licence agreement available at:
      http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end
end
