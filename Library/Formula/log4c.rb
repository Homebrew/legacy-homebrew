class Log4c < Formula
  desc "Logging Framework for C"
  homepage "http://log4c.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"

  head ":pserver:anonymous:@log4c.cvs.sourceforge.net:/cvsroot/log4c", :using => :cvs

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
