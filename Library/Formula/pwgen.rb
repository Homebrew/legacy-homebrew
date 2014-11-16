require 'formula'

class Pwgen < Formula
  homepage 'http://pwgen.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/pwgen/pwgen/2.06/pwgen-2.06.tar.gz'
  sha1 '43dc4fbe6c3bdf96ae24b20d44c4a4584df93d8e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/pwgen", '--secure', '20', '10'
  end
end
