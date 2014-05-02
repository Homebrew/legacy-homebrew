require 'formula'

class GnuProlog < Formula
  homepage 'http://www.gprolog.org/'
  url 'http://gprolog.univ-paris1.fr/gprolog-1.4.4.tar.gz'
  sha1 '658b0efa5d916510dcddbbd980d90bc4d43a6e58'

  # Upstream patch:
  # http://sourceforge.net/p/gprolog/code/ci/784b3443a0a2f087c1d1e7976739fa517efe6af6
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7549696/raw/3078eef282ca141c95a0bf74396f4248bbe34775/gprolog-clang.patch"
    sha1 "8af7816a97bd1319fbd3ae52cedc02ccc9164d27"
  end

  def install
    cd 'src' do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      system "make"
      ENV.deparallelize
      system "make", "install"
    end
  end
end
