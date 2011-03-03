require 'formula'

class BaliPhy <Formula
  url 'http://www.biomath.ucla.edu/msuchard/bali-phy/bali-phy-2.1.0.tar.gz'
  homepage 'http://www.biomath.ucla.edu/msuchard/bali-phy/'
  md5 'ce5d96d464c3a8957caf6683f5b4ee2c'

  depends_on 'gsl'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
