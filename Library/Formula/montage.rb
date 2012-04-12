require 'formula'

class Montage < Formula
  url 'http://montage.ipac.caltech.edu/download/Montage_v3.3.tar.gz'
  homepage 'http://montage.ipac.caltech.edu'
  md5 '875a88b4a2396a0eb5d0006a656e9c4a'

  def install
    system "make"
    bin.install Dir['bin/m*']
  end

  def caveats; <<-EOS.undent
    Montage is under the Caltech/JPL non-exclusive, non-commercial software licence agreement
    available at http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end
end
