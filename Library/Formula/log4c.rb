class Log4c < Formula
  desc "Logging Framework for C"
  homepage 'http://log4c.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz'
  sha1 'a2795d7fcbdf5e43e1cc644893adfa725046abe8'

  head ":pserver:anonymous:@log4c.cvs.sourceforge.net:/cvsroot/log4c", :using => :cvs

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
