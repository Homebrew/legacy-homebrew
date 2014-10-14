require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  depends_on 'xz' => :optional

  bottle do
    cellar :any
    sha1 "0e5d1b4f626533dfa2ff13787c4d43a500f36d93" => :mavericks
    sha1 "a894d93ee0bd3f3c339b52ffd4b19c818a7bcab0" => :mountain_lion
    sha1 "322b708d62733c3a4b5054b3fa839a2b2801193e" => :lion
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-lzo2",
                          "--without-nettle",
                          "--without-xml2"
    system "make install"
  end
end
