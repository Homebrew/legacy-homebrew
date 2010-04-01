require 'formula'

class Cherokee <Formula
  url 'http://www.cherokee-project.com/download/0.99/0.99.44/cherokee-0.99.44.tar.gz'
  homepage 'http://www.cherokee-project.com/'
  md5 '268e7130c12b441523de963f95b9b85d'

  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
