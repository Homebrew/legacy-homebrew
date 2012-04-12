require 'formula'

class Cfengine < Formula
  url 'https://cfengine.com/source-code/download?file=cfengine-3.3.0.tar.gz'
  homepage 'http://cfengine.com/'
  md5 'd40426fcc447e6f1581a6abd6116ea20'

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
