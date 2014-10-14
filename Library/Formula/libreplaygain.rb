require 'formula'

class Libreplaygain < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/libreplaygain_r475.tar.gz'
  version 'r475'
  sha1 '7739b4b9cf46e0846663f707a9498a4db0345eaf'

  bottle do
    cellar :any
    sha1 "f32ba6f8190b3f1509bedc80b61529b517e3d68a" => :mavericks
    sha1 "072fb9552e50cdbb38ccc1008d43301384c5bfe6" => :mountain_lion
    sha1 "69fe997a4ed990b62bc596046a190f450f2bb47c" => :lion
  end

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    include.install 'include/replaygain/'
  end
end
