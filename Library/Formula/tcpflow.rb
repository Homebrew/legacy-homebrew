require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'http://www.digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.4.tar.gz'
  sha1 'e4bc5ad08a81a39943bd1c799edefcdee09de784'

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
