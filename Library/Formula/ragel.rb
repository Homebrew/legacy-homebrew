require 'formula'

class RagelUserGuide < Formula
  url 'http://www.complang.org/ragel/ragel-guide-6.7.pdf'
  sha1 '6f3483fea075941c989ac37e6c49afabc7e181c0'
end

class Ragel < Formula
  homepage 'http://www.complang.org/ragel/'
  url 'http://www.complang.org/ragel/ragel-6.7.tar.gz'
  md5 'f4423e0d8a6538dd4e61498fcfad3cec'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    # Install the prebuilt PDF documentation
    RagelUserGuide.new.brew { doc.install Dir['*.pdf'] }
  end
end
