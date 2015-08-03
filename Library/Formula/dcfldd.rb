class Dcfldd < Formula
  desc "Enhanced version of dd for forensics and security"
  homepage "http://dcfldd.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dcfldd/dcfldd/1.3.4-1/dcfldd-1.3.4-1.tar.gz"
  sha256 "f5143a184da56fd5ac729d6d8cbcf9f5da8e1cf4604aa9fb97c59553b7e6d5f8"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
