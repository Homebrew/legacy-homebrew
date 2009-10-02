require 'brewkit'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v1.6.0/rabbitmq-server-1.6.0.tar.gz'
  md5 'af3b0d868d58e5aefb4f0837b82ca010'

  depends_on 'erlang'

  def install
    erlang_libdir = lib + "rabbitmq" + "erlang" + "lib"
    target_dir = "#{erlang_libdir}/rabbitmq-#{version}"
    system "make"
    system "TARGET_DIR=#{target_dir} \
                MAN_DIR=#{man} \
                SBIN_DIR=#{sbin} \
                make install"

    (etc + "rabbitmq").mkpath
    (var + "lib" + "rabbitmq").mkpath
    (var + "log" + "couchdb").mkpath

    %w{rabbitmq-server rabbitmq-multi rabbitmqctl}.each do |script|
      inreplace sbin+script, '/etc/rabbitmq', "#{etc}/rabbitmq"
      inreplace sbin+script, '/var/log/rabbitmq', "#{var}/log/rabbitmq"
      inreplace sbin+script, '/var/lib/rabbitmq', "#{var}/lib/rabbitmq"
      # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
      # therefore need to add this path for erl -pa
      inreplace sbin+script, '`dirname $0`/..', "#{target_dir}"
    end
  end
end
