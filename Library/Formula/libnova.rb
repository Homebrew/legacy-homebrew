require 'formula'

class Libnova < Formula
  homepage 'http://libnova.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/libnova/libnova/v%200.15.0/libnova-0.15.0.tar.gz'
  sha1 '4b8d04cfca0be8d49c1ef7c3607d405a7a8b167d'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

end
