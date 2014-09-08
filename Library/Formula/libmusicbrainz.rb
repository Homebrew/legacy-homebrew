require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org/doc/libmusicbrainz'
  url 'https://github.com/downloads/metabrainz/libmusicbrainz/libmusicbrainz-5.0.1.tar.gz'
  sha1 'd4823beeca3faf114756370dc7dd6e3cd01d7e4f'

  bottle do
    cellar :any
    sha1 "fc24a0733163d3d56c85b7efa16c855a17e77d63" => :mavericks
    sha1 "71407930a3ce821e29f23a06a26198950085fd37" => :mountain_lion
    sha1 "7df1778e99122eda79111d0dfbd44b354c877838" => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'neon'

  def install
    neon = Formula["neon"]
    neon_args = %W[-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib
                 -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon]
    system "cmake", ".", *(std_cmake_args + neon_args)
    system "make install"
  end
end
