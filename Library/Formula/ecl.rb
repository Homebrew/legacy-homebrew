require 'formula'

class Ecl < Formula
  homepage 'http://ecls.sourceforge.net/'
  url 'http://sourceforge.net/projects/ecls/files/ecls/12.7/ecl-12.7.1.tar.gz'
  sha1 'c5b81d0dc5fdd6c72af99dc883752bfee85028dc'

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
