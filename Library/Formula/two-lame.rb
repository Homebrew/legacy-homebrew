require 'formula'

class TwoLame < Formula
  homepage 'http://www.twolame.org/'
  url 'http://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz'
  sha1 '3ca460472c2f6eeedad70291d8e37da88b64eb8b'

  option 'frontend', 'Build the twolame frontend using libsndfile'

  depends_on 'libsndfile' if build.include? 'frontend'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
