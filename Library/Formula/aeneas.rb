require 'formula'

class Aeneas <Formula
  url 'http://ftp.gnu.org/gnu/aeneas/aeneas-1.2.tar.gz'
  homepage 'http://www.gnu.org/software/aeneas/'
  md5 '268683f42732aca75d9ac21f23a144dc'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
