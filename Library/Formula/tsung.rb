require 'formula'

class Tsung <Formula
  url 'http://tsung.erlang-projects.org/dist/tsung-1.3.2.tar.gz'
  homepage 'http://tsung.erlang-projects.org/'
  md5 '6de503c41e608b25e4fe8fb058edc9cc'

  depends_on 'erlang'
  depends_on 'gnuplot'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
