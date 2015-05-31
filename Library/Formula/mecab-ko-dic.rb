class MecabKoDic < Formula
  desc "MeCab-ko dictionary"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.0-20150517.tar.gz"
  sha256 "dcef1f7624f0f1c2934c85982000789fab10689e53aa657131f1cfaa523ca001"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "mecab-ko"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{prefix}"
    system "make", "install"

    if File.readlines("#{etc}/mecabrc").grep(/^dicdir.*=/).empty?
      open("#{etc}/mecabrc", "a") { |f| f.puts "dicdir = #{opt_prefix}\n" }
    end
  end
end
