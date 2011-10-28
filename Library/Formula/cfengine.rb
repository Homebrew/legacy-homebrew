require 'formula'

class Cfengine < Formula
  url 'https://cfengine.com/source_code/download?file=cfengine-3.2.0.tar.gz'
  homepage 'http://cfengine.com/'
  md5 '5fdd5a0bf6c5111114ee8fb2259483ae'

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
