require 'formula'

class YleDl < Formula
  homepage 'http://aajanki.github.io/yle-dl/'
  url 'https://github.com/downloads/aajanki/yle-dl/yle-dl-2.0.2.tar.gz'
  sha1 'c48866daf24e9f427184c8bc51a018d250a003cf'

  head 'https://github.com/aajanki/yle-dl.git'

  depends_on 'rtmpdump'
  depends_on :python  # use python because of pycrypto
  depends_on LanguageModuleDependency.new :python, 'pycrypto', 'Crypto'

  def install
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
  end

  test do
    raise if (`#{bin}/yle-dl --help 2>&1` =~ /rtmpdump: This program dumps the media content streamed over RTMP/).nil?
  end
end
