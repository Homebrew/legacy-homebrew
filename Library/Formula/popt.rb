class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "http://rpm5.org"
  url "http://rpm5.org/files/popt/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    revision 1
    sha256 "60a7f19e8fecafd92a5beb7d6438efac915e8f3afe3d83575fb64bb4a6190aab" => :el_capitan
    sha256 "56d1104516e23bb314a248904b8ec85afe2fdbf71555417eb8f91edc1286e6da" => :yosemite
    sha256 "ba122e7f34b9b03ab5a32ab01124b61eb608c29e0c0d023462953ed03782dd2a" => :mavericks
    sha256 "6d95c3530a7bd4d7099d91f448669b53bb51a071c5e9a8b9915cdc750bd72aec" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
