require "formula"

class Protocolbuffers < Formula
  homepage "https://code.google.com/p/metasyntactic/wiki/ProtocolBuffers"
  url "https://metasyntactic.googlecode.com/files/ProtocolBuffers-2.2.0-Source.tar.gz"
  sha1 "c9e5be9d013429acd514775ee76fa8d0acd900f1"

  #patch missing include, adapted from https://code.google.com/p/protobuf/issues/detail?id=455
  patch :DATA

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    #system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
        system "#{bin}/protoc"
  end
end

__END__
diff --git a/src/google/protobuf/message.cc b/src/google/protobuf/message.cc
index 4e5b662..6013677 100644
--- a/src/google/protobuf/message.cc
+++ b/src/google/protobuf/message.cc
@@ -48,6 +48,7 @@
 #include <google/protobuf/stubs/strutil.h>
 #include <google/protobuf/stubs/map-util.h>
 #include <google/protobuf/stubs/stl_util-inl.h>
+#include <istream>
 
 namespace google {
 namespace protobuf {
