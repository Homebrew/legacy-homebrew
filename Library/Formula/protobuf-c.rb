require 'formula'

class ProtobufC < Formula
  homepage 'http://code.google.com/p/protobuf-c/'
  url 'https://protobuf-c.googlecode.com/files/protobuf-c-0.15.tar.gz'
  sha1 '4fbd93f492c52154713de1951c0a2133ddd43abb'

  bottle do
    cellar :any
    sha1 "078262944c1f44a05d9702ff6775036ad342ab98" => :mavericks
    sha1 "35dd522279be5cd04a0e5c33e01d6f0680250963" => :mountain_lion
    sha1 "26bcfd1a485c615ab40987f80a892d5d2902d17b" => :lion
  end

  depends_on 'protobuf'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
