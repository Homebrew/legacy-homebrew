require 'formula'

class Muttprofile < Formula
  url 'http://www.acoustics.hut.fi/~mara/mutt/muttprofile'
  homepage 'http://www.acoustics.hut.fi/~mara/mutt/muttprofile.html'
  md5 'b292d75ed65cd4776628808d715430f1'
  version '1.0.1'

  def install
    bin.install "muttprofile"
  end
end
