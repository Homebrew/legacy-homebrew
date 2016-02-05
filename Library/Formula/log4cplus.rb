class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "http://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.2.0/log4cplus-1.2.0.tar.xz"
  sha256 "93aa5b26425f0b1596c5e5b3d58916988fdd83b359a02ca59878eb5c7c2ec6c2"

  bottle do
    cellar :any
    sha256 "d051d31f4d76a18a70f21d10b3037e3fdad202d18acedbb158874f26a57ec104" => :el_capitan
    sha256 "47cbed5a69741494a419d04bebfe8755172f98d8cb66cc228174529630321373" => :yosemite
    sha256 "c60007704e699c4baeabad262b9600e5d0b8d8e217588c6e69f429b5f60d876d" => :mavericks
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
