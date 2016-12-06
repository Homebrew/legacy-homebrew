require 'formula'

class Hmmer < Formula
  url 'ftp://selab.janelia.org/pub/software/hmmer3/3.0/hmmer-3.0.tar.gz'
  homepage 'http://hmmer.janelia.org/'
  md5 '4cf685f3bc524ba5b5cdaaa070a83588'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
