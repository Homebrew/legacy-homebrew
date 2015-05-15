class MongoC < Formula
  homepage "https://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.1.5/mongo-c-driver-1.1.5.tar.gz"
  sha256 "ebad1af02c50b6db20bb9ca988d1050b97c13bed65e9de8b5ac93eee71115c29"

  bottle do
    cellar :any
    sha256 "767da53feade70a23f1cd302b2c442f2a5ee0fcdb7f0e2633cf0c7ad4c60f2bc" => :yosemite
    sha256 "805d4470878d76233e5c4cb08878d907ed85ac0aacf84c704fafb51b8300b3c7" => :mavericks
    sha256 "4f591e9b09ac501ece9161f23d98f9ad4d7fa5ba79a5fcc2478a958b02eb7f0a" => :mountain_lion
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

    if build.with?("openssl")
      args << "--enable-ssl=yes"
    else
      args << "--enable-ssl=no"
    end

    system "./configure", *args
    system "make", "install"
  end
end
