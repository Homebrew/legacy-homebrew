require 'formula'

class JsonC < Formula
  homepage 'https://github.com/json-c/json-c/wiki'
  url 'https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz'
  version '0.11'
  sha1 '1910e10ea57a743ec576688700df4a0cabbe64ba'

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
