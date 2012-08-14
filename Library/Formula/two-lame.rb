require 'formula'

class TwoLame < Formula
  homepage 'http://www.twolame.org/'
  url 'http://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz'
  sha1 '3ca460472c2f6eeedad70291d8e37da88b64eb8b'

  depends_on 'libsndfile' if ARGV.include? '--frontend'

  def options
    [['--frontend', 'Build the twolame frontend using libsndfile']]
  end

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system 'make install'
  end
end
