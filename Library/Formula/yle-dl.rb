require 'formula'

class YleDl < Formula
  homepage 'http://aajanki.github.com/yle-dl/'
  url 'https://github.com/downloads/aajanki/yle-dl/yle-dl-2.0.2.tar.gz'
  sha1 'c48866daf24e9f427184c8bc51a018d250a003cf'

  head 'https://github.com/aajanki/yle-dl.git'

  depends_on 'rtmpdump'
  depends_on LanguageModuleDependency.new :python, 'pycrypto', 'Crypto'

  def install
    system "make install SYS=darwin prefix=#{prefix} mandir=#{man}"
  end

  test do
    news = "yle-areena-uutiset.flv"
    system "yle-dl --latestepisode --resume -o #{news} http://areena.yle.fi/?q=uutiset"
    File.exists?(news)
  end
end
