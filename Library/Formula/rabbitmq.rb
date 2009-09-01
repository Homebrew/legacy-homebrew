require 'brewkit'

class Rabbitmq <Formula
  @homepage='http://rabbitmq.com'
  @url='http://www.rabbitmq.com/releases/rabbitmq-server/v1.6.0/rabbitmq-server-1.6.0.tar.gz'
  @md5='af3b0d868d58e5aefb4f0837b82ca010'

  depends_on 'erlang'

  def erlang_libdir
    prefix + "lib" + "erlang" + "lib"
  end

  def install
    system "make"
    system "TARGET_DIR=#{erlang_libdir}/rabbitmq-#{version} \
                MAN_DIR=#{man} \
                SBIN_DIR=#{sbin} \
                make install"
  end
end
