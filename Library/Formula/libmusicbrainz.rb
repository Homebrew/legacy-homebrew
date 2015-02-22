class Libmusicbrainz < Formula
  homepage "https://musicbrainz.org/doc/libmusicbrainz"
  url "https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz"
  sha1 "1576b474c777bb9c4ff906853ef1d3bb14915f50"

  bottle do
    cellar :any
    revision 1
    sha1 "b9055332d11497bcc593273c22379cd3680cb273" => :yosemite
    sha1 "6a7901872fd932805303f258e363e9245773a79c" => :mavericks
    sha1 "869651234ba41e4a878402de4fbb7cacce190aab" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "neon"

  def install
    neon = Formula["neon"]
    neon_args = %W[-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib
                   -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon]
    system "cmake", ".", *(std_cmake_args + neon_args)
    system "make", "install"
  end
end
