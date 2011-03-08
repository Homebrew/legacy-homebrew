require 'formula'

class Mfs <Formula
  url 'http://moosefs.org/tl_files/mfscode/mfs-1.6.20-2.tar.gz'
  homepage 'http://moosefs.org'
  md5 'ce14948b9c3e5e20e1e752338f9cdcbf'
  version '1.6.20.2'


  def caveats
    <<-EOS.undent
      encfs requires MacFUSE 2.6 or later to be installed.
      You can find MacFUSE at:
        http://code.google.com/p/macfuse/
    EOS
  end


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install"
  end
end
