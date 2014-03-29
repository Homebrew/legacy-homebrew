require 'formula'

class Calcurse < Formula
  homepage 'http://calcurse.org/'
  url 'http://calcurse.org/files/calcurse-3.1.4.tar.gz'
  sha1 '5cf0cc458d6508d38aa57a12170499449f09bfd2'

  depends_on 'gettext'

  # Patch sent upstream: https://github.com/cryptocrack/calcurse/pull/1
  patch do
    url "https://github.com/jacknagel/calcurse/commit/86dd23f87bcbb32a69f5f0391439238d4e389d77.patch"
    sha1 "5af66c819acf115e65e4d94ca903df6bbc5274d2"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
