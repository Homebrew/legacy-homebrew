class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "http://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-1.1.0/msgpack-1.1.0.tar.gz"
  sha256 "a8d400e2f0cae811a150f564d95c7ad6f30a77ad4584303de06467234b73f345"

  head do
    url "https://github.com/msgpack/msgpack-c.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "0887c72426c2a85e8aa928c5ab0432085801b11bdf8e28c2de195c5ced614ca1" => :yosemite
    sha256 "dba28a0fba8b053aad351c7890f9ab15d3d6aef5495c4c330054e0c507799532" => :mavericks
    sha256 "b4c6bd00420aa63a3aaf4ac25ebe3755bf7f5530cfb32a4c6e2daa15b97fcc8a" => :mountain_lion
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
