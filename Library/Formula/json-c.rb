require "formula"

class JsonC < Formula
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha1 "b33872f8b2837c7909e9bd8734855669c57a67ce"

  bottle do
    cellar :any
    sha1 "44f79306bc549ac82fb2007184a757e6d94ae320" => :mavericks
    sha1 "0d3169dcd74efedb465598463026dc8c1b3192a1" => :mountain_lion
    sha1 "13d7c03bb2c64a60d392390e693f750ccb38be6c" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make install"
  end
end
