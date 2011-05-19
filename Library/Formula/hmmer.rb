require 'formula'

class Hmmer < Formula
  url 'http://selab.janelia.org/software/hmmer3/3.0/hmmer-3.0.tar.gz'
  homepage 'http://hmmer.janelia.org/'
  md5 '4cf685f3bc524ba5b5cdaaa070a83588'
  version '3.0'

  def install
    system "./configure","--prefix=#{prefix}" #,"--mandir=#{man}"
    system "make install"
  end
end
