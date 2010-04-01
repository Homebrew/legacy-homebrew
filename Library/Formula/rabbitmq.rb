require 'formula'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://mirror.rabbitmq.com/releases/rabbitmq-server/v1.7.2/rabbitmq-server-1.7.2.tar.gz'
  md5 'fb83be3b1577cdd54459012b85b7631d'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MACOS_VERSION < 10.6

  def install
    target_dir = "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    system "make install"

    (etc + "rabbitmq").mkpath
    (var + "lib/rabbitmq").mkpath
    (var + "log/rabbitmq").mkpath

    %w{rabbitmq-server rabbitmq-multi rabbitmqctl rabbitmq-env}.each do |script|
      inreplace sbin+script do |contents|
        contents.gsub! '/etc/rabbitmq', "#{etc}/rabbitmq"
        contents.gsub! '/var/lib/rabbitmq', "#{var}/lib/rabbitmq"
        contents.gsub! '/var/log/rabbitmq', "#{var}/log/rabbitmq"
      end
    end

    # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
    # therefore need to add this path for erl -pa
    inreplace sbin+'rabbitmq-env', '${SCRIPT_DIR}/..', "#{target_dir}"
  end
end
