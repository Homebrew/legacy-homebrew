require 'formula'

class Libao < Formula
  homepage 'http://www.xiph.org/ao/'
  url 'http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz'
  sha1 '6b1d2c6a2e388e3bb6ebea158d51afef18aacc56'

  bottle do
    sha1 "0d085a74af49491b905bd61f3e600faa49ee5ca0" => :mavericks
    sha1 "5d9e119ca1d6d5e0ae766006d484e05e97b5bc79" => :mountain_lion
    sha1 "3194c697e416c4c215a80e6e1fcbf07e8141a5aa" => :lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make install"
  end
end
