require "formula"

class MecabKoDic < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-1.6.0-20140515.tar.gz"
  sha1 "c75a5cf38e48b62133423a8a06c12710b7874f9f"

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
