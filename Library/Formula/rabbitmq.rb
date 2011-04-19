require 'formula'

class Rabbitmq < Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.4.1/rabbitmq-server-2.4.1.tar.gz'
  md5 '6db31b4353bd44f8ae9b6756b0a831e6'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def patches
    # Can't build manpages without a lot of other junk, so disable
    DATA
  end

  def install
    target_dir = "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    system "make install"

    (etc+'rabbitmq').mkpath
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    %w{rabbitmq-server rabbitmqctl rabbitmq-env}.each do |script|
      inreplace sbin+script do |s|
        s.gsub! '/etc/rabbitmq', "#{etc}/rabbitmq"
        s.gsub! '/var/lib/rabbitmq', "#{var}/lib/rabbitmq"
        s.gsub! '/var/log/rabbitmq', "#{var}/log/rabbitmq"
      end
    end

    # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
    # therefore need to add this path for erl -pa
    inreplace sbin+'rabbitmq-env', '${SCRIPT_DIR}/..', target_dir
  end
end

__END__
diff --git a/Makefile b/Makefile
index d3f052f..98ce763 100644
--- a/Makefile
+++ b/Makefile
@@ -267,7 +267,7 @@ $(SOURCE_DIR)/%_usage.erl:

 docs_all: $(MANPAGES) $(WEB_MANPAGES)

-install: install_bin install_docs
+install: install_bin

 install_bin: all install_dirs
	cp -r ebin include LICENSE LICENSE-MPL-RabbitMQ INSTALL $(TARGET_DIR)
