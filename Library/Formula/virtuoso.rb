require 'formula'

class Virtuoso <Formula
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.1/virtuoso-opensource-6.1.1.tar.gz'
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  md5 '0695bffacf78e53733c27e96c9d7f9e7'

  # If gawk isn't found, make fails deep into the process.
  depends_on 'gawk'

  def skip_clean? path
    true
  end

  def caveats
    <<-EOS.undent
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  def install
    ENV.m64 if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
