require 'formula'

class Msgpack < Formula
  homepage 'http://msgpack.org/'
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-1.0.1/msgpack-1.0.1.tar.gz"
  sha256 "a070d27d16133fe508fca72af434cd9e114709fffc1973de3dd3d3e6a987e250"

  bottle do
    cellar :any
    sha256 "b8a0d13a117208b675e398be1d2160d40c31aac1f9bf8a54134818ab13c13e0f" => :yosemite
    sha256 "0e510b434f4e7aae0bc296deb0a6b116a8a89efcbfe6c6727925f44069dda6d6" => :mavericks
    sha256 "60b1eaa967cd9f8be59f9f2f27e0fa936fc224d77a6f794db6e62dc2f4071935" => :mountain_lion
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
