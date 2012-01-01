require 'formula'

class Pcal < Formula
  url 'http://sourceforge.net/projects/pcal/files/latest/download?source=files'
  homepage 'http://pcal.sourceforge.net/'
  version '4.11.0'
  md5 '0ed7e9bec81fe3bdd62f8af283bef704'

  skip_clean :all
  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make"  # separate make and make install steps
    bin.install ['exec/pcal']
    man.mkpath
    # rename man file
    mv('doc/pcal.man', 'doc/pcal.1')
    # and install, then compress
    man1.install ['doc/pcal.1']
    system "compress #{man1}/pcal.1"
    # cat stuff
    mv('doc/pcal.cat', 'doc/pcal.1')
    mkdir("#{man}/cat")
    mv("doc/pcal.1", "#{man}/cat/pcal.1")
    system "compress #{man}/cat/pcal.1"
  end


  def test
    system "pcal"
  end
end
