class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "http://log4cplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.1.2/log4cplus-1.1.2.tar.bz2"
  sha256 "c46d56c96873dcb525791b5ea639d1415e74b1de99d51b657336cb6ebb72ed93"

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
