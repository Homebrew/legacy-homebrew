class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-1.4.1/msgpack-1.4.1.tar.gz"
  sha256 "8ac512f52b30572f0244d6f521847ef3c54a59097dc05b479ac282bf1374f22e"

  bottle do
    cellar :any
    sha256 "ab5e719c5c0e82c16da78e28e54ca44d63e90571bac3ac07a8b3c42e3c2b86f1" => :el_capitan
    sha256 "3b7b6cca59c935e0fc1bedfad8507167c0f20bdd4b45d776d94f43b90113a35d" => :yosemite
    sha256 "8d0cacd65a1a32fc34895c84387a639d2af4a9770568e4351ec479bfa9a570d2" => :mavericks
  end

  head do
    url "https://github.com/msgpack/msgpack-c.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  fails_with :llvm do
    build 2334
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Reference: http://wiki.msgpack.org/display/MSGPACK/QuickStart+for+C+Language
    (testpath/"test.c").write <<-EOS.undent
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

    system ENV.cc, "-o", "test", "test.c", "-lmsgpackc"
    assert_equal "1\n2\n3\n", `./test`
  end
end
