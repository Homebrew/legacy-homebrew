require 'formula'

class Confuse < Formula
  url 'http://savannah.nongnu.org/download/confuse/confuse-2.7.tar.gz'
  homepage 'http://www.nongnu.org/confuse/'
  md5 '45932fdeeccbb9ef4228f1c1a25e9c8f'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
