require 'formula'

class Pcal < Formula
  url 'http://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz'
  homepage 'http://pcal.sourceforge.net/'
  md5 '0ed7e9bec81fe3bdd62f8af283bef704'

  skip_clean :all
  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make"  # separate make and make install steps
    bin.install ['exec/pcal']
    man1.install gzip('doc/pcal.man') => 'pcal.1.gz'
    (man+'cat1').install gzip('doc/pcal.cat') => 'pcal.1.gz'
  end


  def test
    system "#{bin}/pcal"
  end
end
