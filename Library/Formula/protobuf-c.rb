require 'formula'

class ProtobufC < Formula
  homepage 'http://github.com/protobuf-c/protobuf-c'
  url 'https://github.com/protobuf-c/protobuf-c/releases/download/v1.0.0/protobuf-c-1.0.0.tar.gz'
  sha1 '6d48eb6a193556262c35526e1ccf209a6fc69684'

  depends_on 'pkg-config' => :build
  depends_on 'protobuf'

  def install
    ENV.append_path "PKG_CONFIG_PATH", "#{Formula["protobuf"].opt_prefix}/lib/pkgconfig"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
