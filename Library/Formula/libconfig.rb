require 'formula'

class Libconfig < Formula
  homepage 'http://www.hyperrealm.com/libconfig/'
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz'
  sha1 'b7a3c307dfb388e57d9a35c7f13f6232116930ec'

  bottle do
    cellar :any
    sha1 "d806bbf7d1539017ce946820cc998e21134bb04c" => :mavericks
    sha1 "8b8bccfba26165fd0da9c680a4415d9ba8bcc1e1" => :mountain_lion
    sha1 "fdb84a8722d963e77f0e845073c136bf21b78bb5" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
