require 'formula'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v1.7.0/rabbitmq-server-1.7.0.tar.gz'
  md5 '4505ca0fd8718439bd6f5e2af2379e56'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MACOS_VERSION < 10.6

  def install
    erlang_libdir = lib + "rabbitmq" + "erlang" + "lib"
    target_dir = "#{erlang_libdir}/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    system "make install"

    (etc + "rabbitmq").mkpath
    (var + "lib" + "rabbitmq").mkpath
    (var + "log" + "couchdb").mkpath

    %w{rabbitmq-server rabbitmq-multi rabbitmqctl rabbitmq-env}.each do |script|
      inreplace sbin+script do |contents|
        contents.gsub! '/etc/rabbitmq', "#{etc}/rabbitmq"
        contents.gsub! '/var/((log|lib)/rabbitmq)', "#{var}/\1"
      end
    end

    # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
    # therefore need to add this path for erl -pa
    inreplace sbin+'rabbitmq-env', '${SCRIPT_DIR}/..', "#{target_dir}"
  end
end
