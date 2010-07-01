require 'formula'

class Rabbitmq <Formula
  homepage 'http://rabbitmq.com'
  url 'http://mirror.rabbitmq.com/releases/rabbitmq-server/v1.8.0/rabbitmq-server-1.8.0.tar.gz'
  md5 'e00bea375e81d51600b5b14220c64d89'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MACOS_VERSION < 10.6

  def patches
    # remove man pages pending necessary formulae to build them:
    # xmlto, gnu-getopts, docbook-xml, docbook-xsl, docbook-4.5
    DATA
  end

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

__END__
diff --git a/Makefile b/Makefile
index 725f20a..65c94a9 100644
--- a/Makefile
+++ b/Makefile
@@ -243,7 +243,7 @@ $(SOURCE_DIR)/%_usage.erl:
 
 docs_all: $(MANPAGES) $(WEB_MANPAGES)
 
-install: all docs_all install_dirs
+install: all install_dirs
 	cp -r ebin include LICENSE LICENSE-MPL-RabbitMQ INSTALL $(TARGET_DIR)
 
 	chmod 0755 scripts/*
@@ -251,12 +251,6 @@ install: all docs_all install_dirs
 		cp scripts/$$script $(TARGET_DIR)/sbin; \
 		[ -e $(SBIN_DIR)/$$script ] || ln -s $(SCRIPTS_REL_PATH)/$$script $(SBIN_DIR)/$$script; \
 	done
-	for section in 1 5; do \
-		mkdir -p $(MAN_DIR)/man$$section; \
-		for manpage in $(DOCS_DIR)/*.$$section.gz; do \
-			cp $$manpage $(MAN_DIR)/man$$section; \
-		done; \
-	done
 
 install_dirs:
 	@ OK=true && \
