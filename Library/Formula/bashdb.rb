require 'formula'

class Bashdb < Formula
  url 'http://downloads.sourceforge.net/project/bashdb/bashdb/4.2-0.7/bashdb-4.2-0.7.tar.gz'
  homepage 'http://bashdb.sourceforge.net/'
  md5 '6e47011c85bf4532141b726105e11c0a'
  version '4.2-0.7'

  # Needs bash 4.2 but OS X 10.6 ships with 3.2
  depends_on 'bash'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
