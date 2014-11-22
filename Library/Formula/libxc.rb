require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.0.tar.gz'
  sha1 '77c3ffe2c664339f3eafbf7642ddeba482b88074'
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "fb4744280dc39b09b4e911c1791710b3f32b8c73" => :yosemite
    sha1 "690f285d57eb498b07538c0c5c03a45f64082ed8" => :mavericks
    sha1 "185f827d949459e98e0ed491280dbab363bc1bfb" => :mountain_lion
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make install"
  end
end
