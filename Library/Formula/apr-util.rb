require 'formula'

class AprUtil <Formula
  url 'http://archive.apache.org/dist/apr/apr-util-1.3.8.tar.gz'
  homepage 'http://apr.apache.org/'
  md5 'bb9ac31b623be73582f2ced1f65b3856'
  
  version '1.3.8'
  depends_on 'apr'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-apr=#{HOMEBREW_CELLAR}/apr/#{@version}"
    system "make"
    system "make install"    
  end
end
