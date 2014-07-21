require 'formula'

class Calcurse < Formula
  homepage 'http://calcurse.org/'
  url 'http://calcurse.org/files/calcurse-3.1.4.tar.gz'
  sha1 '5cf0cc458d6508d38aa57a12170499449f09bfd2'

  depends_on 'gettext'

  # Patch sent upstream: https://github.com/cryptocrack/calcurse/pull/1
  patch do
    url "https://github.com/jacknagel/calcurse/commit/86dd23f87bcbb32a69f5f0391439238d4e389d77.diff"
    sha1 "d9a1036c230e6c8a4702c7a05da6277bac9c4a31"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
