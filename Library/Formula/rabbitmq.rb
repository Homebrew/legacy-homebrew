require 'formula'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://mirror.rabbitmq.com/releases/rabbitmq-server/v2.1.0/rabbitmq-server-2.1.0.tar.gz'
  md5 '53e205032b63d0f70c33e1eb1e26d803'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MACOS_VERSION < 10.6

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

    %w{rabbitmq-server rabbitmq-multi rabbitmqctl rabbitmq-env}.each do |script|
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
index 46b1842..82d71a0 100644
--- a/Makefile
+++ b/Makefile
@@ -265,7 +265,7 @@ $(SOURCE_DIR)/%_usage.erl:

 docs_all: $(MANPAGES) $(WEB_MANPAGES)

-install: all docs_all install_dirs
+install: all install_dirs
 	cp -r ebin include LICENSE LICENSE-MPL-RabbitMQ INSTALL $(TARGET_DIR)

 	chmod 0755 scripts/*
@@ -273,12 +273,6 @@ install: all docs_all install_dirs
 		cp scripts/$$script $(TARGET_DIR)/sbin; \
 		[ -e $(SBIN_DIR)/$$script ] || ln -s $(SCRIPTS_REL_PATH)/$$script $(SBIN_DIR)/$$script; \
 	done
-	for section in 1 5; do \
-		mkdir -p $(MAN_DIR)/man$$section; \
-		for manpage in $(DOCS_DIR)/*.$$section.gz; do \
-			cp $$manpage $(MAN_DIR)/man$$section; \
-		done; \
-	done
 	mkdir -p $(TARGET_DIR)/plugins
 	echo Put your .ez plugin files in this directory. > $(TARGET_DIR)/plugins/README

