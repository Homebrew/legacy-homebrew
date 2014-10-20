require 'formula'

class Libsvg < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz'
  sha1 '2198e65833eed905d93be70f3db4f0d32a2eaf57'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "f81bd41636efb5f9bca9668e0d1eba49f2df5668" => :yosemite
    sha1 "7666fa071f1f53c8b680be546b8801cb3067f5a2" => :mavericks
    sha1 "a6644f62ac2844f1b73ad26febb49958a413a54f" => :mountain_lion
  end

  depends_on 'libpng'
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
