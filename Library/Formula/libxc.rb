require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.0.tar.gz'
  sha1 '77c3ffe2c664339f3eafbf7642ddeba482b88074'

  bottle do
    cellar :any
    sha1 "c7f065c9f4f19b394e5b2b7eaac709c42a80b650" => :mavericks
    sha1 "21cc9447ac42f8442f2c7a11b81680951f296637" => :mountain_lion
    sha1 "d13f0f408f6cd0c5ecf95dd057ea3981ae36fceb" => :lion
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
