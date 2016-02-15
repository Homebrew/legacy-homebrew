class Libmusicbrainz < Formula
  desc "MusicBrainz Client Library"
  homepage "https://musicbrainz.org/doc/libmusicbrainz"
  url "https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz"
  sha256 "6749259e89bbb273f3f5ad7acdffb7c47a2cf8fcaeab4c4695484cef5f4c6b46"

  bottle do
    cellar :any
    sha256 "0851c7889df9dc2971b60fe9fd8ad891afd8d5dae08877393e2f69e3cc33f589" => :yosemite
    sha256 "44fa04315d5bbda3e6b9e6ce20a6140c93d535d8c58e8816c574a7e6d4b90429" => :mavericks
    sha256 "e187188a465f4464c2d294cf10e3058c4e3fdbe76c49a346b996f3c108e68ead" => :mountain_lion
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
