class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "http://log4cpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.1.tar.gz"
  sha256 "35abf332630a6809c969276b1d60b90c81a95daf24c86cfd7866ffef72f9bed0"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
