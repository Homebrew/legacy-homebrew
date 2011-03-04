require 'formula'

class Dtach <Formula
  url 'http://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz'
  md5 'ec5999f3b6bb67da19754fcb2e5221f3'
  homepage 'http://dtach.sourceforge.net/'

  def install
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    system "make"
    bin.install "dtach"
    man1.install gzip("dtach.1")
  end
end
