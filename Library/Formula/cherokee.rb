require 'formula'

class Cherokee <Formula
  url 'http://www.cherokee-project.com/download/0.99/0.99.36/cherokee-0.99.36.tar.gz'
  homepage 'http://www.cherokee-project.com/'
  md5 '2b47f70c60de0c6e8ca487f6ccacb9f5'

  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
