require 'formula'

class Libmusicbrainz < Formula
  homepage 'http://musicbrainz.org/doc/libmusicbrainz'
  url 'https://github.com/downloads/metabrainz/libmusicbrainz/libmusicbrainz-5.0.1.tar.gz'
  sha1 'd4823beeca3faf114756370dc7dd6e3cd01d7e4f'

  bottle do
    cellar :any
    revision 1
    sha1 "b9055332d11497bcc593273c22379cd3680cb273" => :yosemite
    sha1 "6a7901872fd932805303f258e363e9245773a79c" => :mavericks
    sha1 "869651234ba41e4a878402de4fbb7cacce190aab" => :mountain_lion
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
