require "formula"

class Sword < Formula
  homepage "http://www.crosswire.org"
  url "ftp://ftp.crosswire.org/pub/sword/source/v1.7/sword-1.7.3.tar.gz"
  sha1 "6ecac6364aa098e150cf8851fd8f97d48df21a34"

  depends_on "icu4c"   => :optional
  depends_on "curl"    => :optional
  depends_on "clucene" => :optional

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-profile",
      "--disable-tests",
    ]

    if build.with? "icu4c"
      args << "--with-icu"
    else
      args << "--without-icu"
    end

    if build.with? "curl"
      args << "--with-curl"
    else
      args << "--without-curl"
    end

    if build.with? "clucene"
      args << "--with-clucene"
    else
      args << "--without-clucene"
    end

    system "./configure", *args
    system "make", "-j4", "install"
  end

  test do
    system "#{bin}/installmgr", "-s"
  end
end
