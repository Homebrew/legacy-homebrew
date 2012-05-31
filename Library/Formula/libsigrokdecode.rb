require 'formula'

class Libsigrokdecode < Formula
  url 'http://downloads.sourceforge.net/project/sigrok/source/libsigrokdecode/libsigrokdecode-0.1.0.tar.gz'
  homepage 'http://sigrok.org'
  md5 '9bc237972f6176ba9dcff057b4e85fd6'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'python3'

  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
