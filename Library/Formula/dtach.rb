require 'formula'

class Dtach < Formula
  url 'http://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz'
  sha1 'fb7279e719463aa284676a78cdf96788f4f2706b'
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
