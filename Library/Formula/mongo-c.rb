require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.1.0/mongo-c-driver-1.1.0.tar.gz"
  sha1 "9277fb0afcf595838da0d5e4715df1526d53e020"

  bottle do
    cellar :any
    sha1 "a1902585054a645fece9ef6e91a53258f3df0356" => :yosemite
    sha1 "53858df7d3bb85e63d070754e2aa8f0e9576266f" => :mavericks
    sha1 "b547c663729e6ec4944462c8d305643dd83d452f" => :mountain_lion
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"
  depends_on "openssl" => :recommended

  def install
    # --enable-sasl=no: https://jira.mongodb.org/browse/CDRIVER-447
    args = ["--prefix=#{prefix}", "--enable-sasl=no"]

    if build.head?
      system "./autogen.sh"
    end

    if build.with?('openssl')
      args << "--enable-ssl=yes"
    else
      args << "--enable-ssl=no"
    end

    system "./configure", *args
    system "make", "install"
  end
end
