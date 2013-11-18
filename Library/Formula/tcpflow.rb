require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'http://www.digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.2.tar.gz'
  sha1 '69c291b4248300ff5caae031a7fa56b533e49779'

  head do
    url 'https://github.com/simsong/tcpflow.git'
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'boost' => :build

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
