require "formula"

class Sword < Formula
  homepage "http://www.crosswire.org"
  url "ftp://ftp.crosswire.org/pub/sword/source/v1.7/sword-1.7.3.tar.gz"
  sha1 "6ecac6364aa098e150cf8851fd8f97d48df21a34"

  # Activates optional unicode support in sword.
  depends_on "icu4c" => :optional
  # Activates optional clucene based text searching capabilities in sword.
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
