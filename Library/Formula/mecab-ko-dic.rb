require "formula"

class MecabKoDic < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-1.6.1-20140814.tar.gz"
  sha1 "f68a6faf9aa86691de5a1abace65e70571972d03"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on 'mecab-ko'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{prefix}"
    system "make install"

    if File.readlines("#{etc}/mecabrc").grep(/^dicdir.*=/).empty?
      open("#{etc}/mecabrc", "a") { |f| f.puts "dicdir = #{opt_prefix}\n" }
    end
  end
end
