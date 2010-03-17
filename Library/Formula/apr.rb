require 'formula'

class Apr <Formula
  url 'http://archive.apache.org/dist/apr/apr-1.3.8.tar.gz'
  homepage 'http://apr.apache.org'
  md5 '310fac12285d94a162c488f4b8f1aabc'

 depends_on 'libtool'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
