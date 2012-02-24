require 'formula'

class Cfengine < Formula
  url 'https://cfengine.com/source-code/download?file=cfengine-3.2.3.tar.gz'
  homepage 'http://cfengine.com/'
  md5 'be118dd95537221da38008845fc0d84a'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--with-tokyocabinet", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "/usr/bin/make install"
  end

  def test
    system "#{sbin}/cf-agent -V"
  end
end
