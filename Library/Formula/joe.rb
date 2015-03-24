require 'formula'

class Joe < Formula
  homepage 'http://joe-editor.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.0/joe-4.0.tar.gz'
  sha1 'a51827c8c61c3cb09a038d8f6670efe84e144927'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

end
