require "formula"

class MecabKoDic < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-1.6.1-20140515.tar.gz"
  sha1 "d882247937be96e36e2ae3f5a0ec6eeb376242fa"

  depends_on :autoconf
  depends_on :automake
  depends_on 'mecab-ko'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To enable the dictionary, add the following to #{HOMEBREW_PREFIX}/etc/mecabrc:
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS
  end
end
