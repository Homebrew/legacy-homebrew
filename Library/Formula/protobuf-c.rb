require "formula"

class ProtobufC < Formula
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.0.1/protobuf-c-1.0.1.tar.gz"
  sha1 "5928059292462aa6696c38857a3ca541a54f1b3f"

  bottle do
    sha1 "46572020e49936035b3f35194c40f98d90fd8dcd" => :mavericks
    sha1 "5fe4ec31d10b064fc580ae5958873ca038083a80" => :mountain_lion
    sha1 "64e31c97b2ef834d6406d128892575706b17cbad" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
