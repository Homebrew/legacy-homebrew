require 'formula'

class Libmodbus < Formula
  homepage 'http://libmodbus.org'
  url 'http://libmodbus.org/site_media/build/libmodbus-3.1.1.tar.gz'
  sha1 '3878af4a93a01001dd3bb8db90d24d5180545b91'

  bottle do
    cellar :any
    sha1 "e6087a19d38f5c2a04fd1605ac97601bec7e578a" => :mavericks
    sha1 "56380a371bb9c5970287ee1071abe162e2c82ab7" => :mountain_lion
    sha1 "efc4d4d0873b838f6124440262afd44675e44f4d" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
