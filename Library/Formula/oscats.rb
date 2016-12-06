require 'formula'

class Oscats < Formula
  homepage 'http://code.google.com/p/oscats/'
  url 'http://oscats.googlecode.com/files/oscats-0.6.tar.gz'
  md5 '7a4df0d8112691ea3a83e7f5dfcb1deb'

  depends_on 'gsl'
  depends_on 'glib'
  depends_on 'pygobject'

  def install
    system "./configure", "--disable-dependency-tracking",
                          # "--enable-java-bindings", (errors in JNI headers)
                          # "--enable-perl-bindings",
                          # "--enable-php-bindings",
                          "--enable-python-bindings",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
