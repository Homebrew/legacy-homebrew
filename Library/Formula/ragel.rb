require 'formula'

class RagelUserGuide < Formula
  url 'http://www.complang.org/ragel/ragel-guide-6.8.pdf'
  sha1 'e57ee7f740dd395d4d5330949594a02c91ad0308'
end

class Ragel < Formula
  homepage 'http://www.complang.org/ragel/'
  url 'http://www.complang.org/ragel/ragel-6.8.tar.gz'
  sha1 '95cabbcd52bd25d76c588ddf11e1fd242d7cbcc7'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    # Install the prebuilt PDF documentation
    RagelUserGuide.new.brew { doc.install Dir['*.pdf'] }
  end
end
