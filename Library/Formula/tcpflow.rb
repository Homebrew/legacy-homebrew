require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'https://github.com/downloads/simsong/tcpflow/tcpflow-1.3.0.tar.gz'
  sha1 'fccd0a451bf138e340fc3b55dfc07924c0a811d8'

  head do
    url 'https://github.com/simsong/tcpflow.git'
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
