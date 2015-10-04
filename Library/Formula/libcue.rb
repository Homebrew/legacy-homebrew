class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "http://sourceforge.net/projects/libcue/"
  url "https://downloads.sourceforge.net/project/libcue/libcue/1.4.0/libcue-1.4.0.tar.bz2"
  sha256 "8b7276ec2a2b3918cbc59a3cc03c68dc0775965cc20e4b88757b852ff369729e"

  bottle do
    cellar :any
    revision 1
    sha256 "cc35f80989bb79d69fe7eb1e2c467961fa80e56318311bcf079f35626b14ac84" => :el_capitan
    sha1 "4f77185f22c3099fe9f310494dedb9ac7913be77" => :yosemite
    sha1 "16e526dbe49a96dd8c9bd688b31195d756dd7bf0" => :mavericks
    sha1 "baa3227a1734763ba21355a6e403b81a205919d2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
