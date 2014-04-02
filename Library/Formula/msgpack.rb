require 'formula'

class Msgpack < Formula
  homepage 'http://msgpack.org/'
  url 'http://msgpack.org/releases/cpp/msgpack-0.5.7.tar.gz'
  sha256 '7c203265cf14a4723820e0fc7ac14bf4bad5578f7bc525e9835c70cd36e7d1b8'

  bottle do
    cellar :any
    sha1 "b0003c9029ef802f425be65724556e9eadb792bd" => :mavericks
    sha1 "f47ff4b3c871244a8bebbac1072ef37010acc3ad" => :mountain_lion
    sha1 "c8e0d36c6aa4dc1c9163f2d3d64ea748ff2b0728" => :lion
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
