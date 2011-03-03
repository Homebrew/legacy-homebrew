require 'formula'

class Ecl <Formula
  url 'http://downloads.sourceforge.net/project/ecls/ecls/11.1/ecl-11.1.1.tar.gz'
  homepage 'http://ecls.sourceforge.net/'
  md5 '6963cfa00e1c6d4a2123fd62100b02e6'

  # doesn't start otherwise
  skip_clean 'bin'
  skip_clean 'lib'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-unicode"
    system "make"
    system "make install"
  end
end
