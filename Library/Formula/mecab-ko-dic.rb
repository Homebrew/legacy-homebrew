class MecabKoDic < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-1.6.1-20140814.tar.gz"
  sha256 "251fb141f2e96d34ea62f557c146ab0615dea67502cce8811d408309f182cfb7"

  bottle do
    cellar :any
    sha256 "92be006bcc8552fdaddf82d21b9f8f528af010128febc721a5a5ba262eca99ce" => :yosemite
    sha256 "0c958bf826cd358431f144dfb3d2d3da08c67cda59efe1d2998b54a401678515" => :mavericks
    sha256 "b932747391e494b10a0fd8cd6002eb857f7a4ccb8e0ea2ea2a3a7b675bf6c237" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "mecab-ko"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/mecab-ko-dic"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-ko-dic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "화학 이외의 것\n", 0)
  end
end
