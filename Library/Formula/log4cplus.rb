class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "http://log4cplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.2.0/log4cplus-1.2.0.tar.xz"
  sha256 "93aa5b26425f0b1596c5e5b3d58916988fdd83b359a02ca59878eb5c7c2ec6c2"

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
