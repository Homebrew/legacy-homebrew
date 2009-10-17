require 'formula'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v1.7.0/rabbitmq-server-1.7.0.tar.gz'
  md5 '4505ca0fd8718439bd6f5e2af2379e56'

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

    %w{rabbitmq-server rabbitmq-multi rabbitmqctl rabbitmq-env}.each do |script|
      inreplace sbin+script, '/etc/rabbitmq', "#{etc}/rabbitmq"
      inreplace sbin+script, '/var/log/rabbitmq', "#{var}/log/rabbitmq"
      inreplace sbin+script, '/var/lib/rabbitmq', "#{var}/lib/rabbitmq"
    end

    %w{rabbitmq-env}.each do |script|
      # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
      # therefore need to add this path for erl -pa
      inreplace sbin+script, '${SCRIPT_DIR}/..', "#{target_dir}"
    end
  end
end
