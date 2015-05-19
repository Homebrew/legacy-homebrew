require 'formula'

class Libconfig < Formula
  desc "Configuration file processing library"
  homepage 'http://www.hyperrealm.com/libconfig/'
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz'
  sha1 'b7a3c307dfb388e57d9a35c7f13f6232116930ec'

  bottle do
    cellar :any
    revision 1
    sha1 "28fca89d671c8ebf4f97ac7a6706675e8b957b2f" => :yosemite
    sha1 "21f6d02c17ab809a63b076dec69d0bc5dbc8f605" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
