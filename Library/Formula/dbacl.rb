require 'formula'

class Dbacl < Formula
  homepage 'http://dbacl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/dbacl/dbacl/1.14.1/dbacl-1.14.1.tar.gz'
  sha1 '47ab878b73f7a782b34a348cfccdff6e4c9043c1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
