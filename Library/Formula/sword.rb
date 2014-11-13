require "formula"

class Sword < Formula
  homepage "http://www.crosswire.org/sword/index.jsp"
  url "ftp://ftp.crosswire.org/pub/sword/source/v1.7/sword-1.7.3.tar.gz"
  sha1 "6ecac6364aa098e150cf8851fd8f97d48df21a34"

  bottle do
    sha1 "8fc45d81b7fcc7d1feffdc130f6c139ffc382db4" => :yosemite
    sha1 "148fd1c7b4358bb3f97979022f65b113afabb856" => :mavericks
    sha1 "36eedc14308de364ebfb1e2fecfc86852b65e3cf" => :mountain_lion
  end

  option "with-icu4c", "Uses icu4c for unicode support"
  depends_on "icu4c" => :optional
  option "with-clucene", "Uses clucene for text searching capabilities"
  depends_on "clucene" => :optional

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-profile",
      "--disable-tests",
      "--with-curl", # use system curl
    ]

    if build.with? "icu4c"
      args << "--with-icu"
    else
      args << "--without-icu"
    end

    if build.with? "clucene"
      args << "--with-clucene"
    else
      args << "--without-clucene"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
