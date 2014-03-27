require 'formula'

class Libyaml < Formula
  homepage 'http://pyyaml.org/wiki/LibYAML'
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz'
  sha1 'f3d404e11bec3c4efcddfd14c42d46f1aabe0b5d'

  bottle do
    cellar :any
    sha1 "9aceef2301eaf12ac675c14706927e2d8889b7be" => :mavericks
    sha1 "72c026103aafa9cba293d0213ddec6028de98b63" => :mountain_lion
    sha1 "23909c4982f4d786c7339f6dfad09487561ce0f2" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
