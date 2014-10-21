require 'formula'

class Cracklib < Formula
  homepage 'http://cracklib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.0/cracklib-2.9.0.tar.gz'
  sha1 '827dcd24b14bf23911c34f4226b4453b24f949a3'

  bottle do
    cellar :any
    revision 1
    sha1 "1d4005c5e5401a3104255efb1ae88f5396984f2c" => :yosemite
    sha1 "232a22e23e25dd71405fe869050dfd82bb5141e0" => :mavericks
    sha1 "50d5faf0c5c3a46985382340e311263de9c363a6" => :mountain_lion
  end

  depends_on "gettext"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-default-dict=#{HOMEBREW_PREFIX}/share/cracklib-words"
    system "make install"
  end
end
