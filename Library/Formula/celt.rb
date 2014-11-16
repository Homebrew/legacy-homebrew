require 'formula'

class Celt < Formula
  homepage 'http://www.celt-codec.org/'
  url 'http://downloads.xiph.org/releases/celt/celt-0.11.1.tar.gz'
  sha256 '01c2579fba8b283c9068cb704a70a6e654aa74ced064c091cafffbe6fb1d4cbf'

  bottle do
    cellar :any
    sha1 "0b75c5cfd5ae35ad102268485d87cb8f15ecc7b9" => :mavericks
    sha1 "c64fce88b8df1acb3f67d8f7645ad81c59f69da1" => :mountain_lion
    sha1 "ed048e43a76a5b9adf4dbd04a3ea5490a50ea559" => :lion
  end

  depends_on 'libogg' => :optional

  fails_with :llvm do
    build 2335
    cause "'make check' fails"
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
