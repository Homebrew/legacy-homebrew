require 'formula'

class Msgpack < Formula
  homepage 'http://msgpack.org/'
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-0.5.9/msgpack-0.5.9.tar.gz"
  sha256 "6139614b4142df3773d74e9d9a4dbb6dd0430103cfa7b083e723cde0ec1e7fdd"

  bottle do
    cellar :any
    revision 1
    sha1 "2db320f8fbaacf5498ed272bbd4b3aefc0549441" => :yosemite
    sha1 "ad96cca40edebefeb5594147c4476840ad9b3d3c" => :mavericks
    sha1 "463ffe2e1df919f83adb3050ab2623b1c34b6ce6" => :mountain_lion
  end

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    # Reference: http://wiki.msgpack.org/display/MSGPACK/QuickStart+for+C+Language
    (testpath/'test.c').write <<-EOS.undent
      #include <msgpack.h>
      #include <stdio.h>

      int main(void)
      {
         msgpack_sbuffer* buffer = msgpack_sbuffer_new();
         msgpack_packer* pk = msgpack_packer_new(buffer, msgpack_sbuffer_write);
         msgpack_pack_int(pk, 1);
         msgpack_pack_int(pk, 2);
         msgpack_pack_int(pk, 3);

         /* deserializes these objects using msgpack_unpacker. */
         msgpack_unpacker pac;
         msgpack_unpacker_init(&pac, MSGPACK_UNPACKER_INIT_BUFFER_SIZE);

         /* feeds the buffer. */
         msgpack_unpacker_reserve_buffer(&pac, buffer->size);
         memcpy(msgpack_unpacker_buffer(&pac), buffer->data, buffer->size);
         msgpack_unpacker_buffer_consumed(&pac, buffer->size);

         /* now starts streaming deserialization. */
         msgpack_unpacked result;
         msgpack_unpacked_init(&result);

         while(msgpack_unpacker_next(&pac, &result)) {
             msgpack_object_print(stdout, result.data);
             puts("");
         }
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-lmsgpack"
    assert_equal "1\n2\n3\n", `./test`
  end
end
