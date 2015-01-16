require 'formula'

class Kytea < Formula
  homepage 'http://www.phontron.com/kytea/'
  url 'http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz'
  sha1 '684f6b90bd4ae048ea3a6fc9762b1baecb006eb3'

  head do
    url 'https://github.com/neubig/kytea.git'
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
