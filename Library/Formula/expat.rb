require 'formula'

class Expat < Formula
  homepage 'http://expat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz'
  sha1 'b08197d146930a5543a7b99e871cba3da614f6f0'

  bottle do
    cellar :any
    sha1 "2d12120ed9ff4835d8c5c31ef1699629dc0f480a" => :mavericks
    sha1 "f2158bd85b4f592df187d2819635dd868b58e023" => :mountain_lion
    sha1 "9be7ecfc6f4e2e58361af84e303214b842c652b7" => :lion
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
