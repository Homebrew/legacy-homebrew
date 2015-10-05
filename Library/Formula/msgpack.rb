class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-1.2.0/msgpack-1.2.0.tar.gz"
  sha256 "a7963b22665cecd1f72d8404b70be95a9c376084e9790833a7942c6633b33ca0"

  bottle do
    cellar :any
    sha256 "0ffcaebf25c82a86a05be2482ef26e756090d247890d24c0ef05cf25d7785807" => :el_capitan
    sha256 "9f378bfd97a6de3830e4246a35cd1be27bc837c7a8f6f235c1304103a3faeee3" => :yosemite
    sha256 "0c390602111beb913cd5737aa2b16b4b271aefa90503af38fe1009c5df188c5a" => :mavericks
    sha256 "3909e41261c4a04249a16ca6980724e3f628e2764f91baed3e278b057b34c6a4" => :mountain_lion
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

    system ENV.cc, "-o", "test", "test.c", "-lmsgpack"
    assert_equal "1\n2\n3\n", `./test`
  end
end
