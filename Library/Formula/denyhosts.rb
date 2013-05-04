require 'formula'

class Denyhosts < Formula
  homepage 'http://denyhosts.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz'
  sha1 '02143843cb7c37c986c222b7acc11f7b75eb7373'

  # Copies of daemon-control-dist & denyhosts.cfg-dist edited for OS X.
  def patches; DATA; end

  def install
    # If the `libpath` is relative, instead of absolute, we can influence the
    # 'data path' via command line arguments to `setup.py`.
    inreplace 'setup.py' do |s|
      s.change_make_var! 'libpath', "''"
      s.change_make_var! 'scriptspath', "''"
      s.change_make_var! 'pluginspath', "''"
    end

    # Make it so that all DenyHosts tools have a default path that points at
    # our config file.
    inreplace 'DenyHosts/constants.py' do |s|
      s.change_make_var! 'CONFIG_FILE', "'#{etc}/denyhosts.cfg'"
    end

    unless MacOS.mountain_lion_or_newer?
      inreplace 'denyhosts.cfg' do |s|
        s.gsub! %r{^SECURE_LOG\s*=\s*/private/var/log/system\.log}, 'SECURE_LOG = /private/var/log/secure.log'
      end
    end

    # Install mostly into libexec (a la Duplicity)
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-lib=#{libexec}",
                     "--install-scripts=#{libexec}",
                     "--install-data=#{libexec}"
    libexec.install 'daemon-control'
    (libexec+'daemon-control').chmod 0755

    # Don't overwrite the config file; the user may have tweaked it.
    etc.install 'denyhosts.cfg' unless (etc + 'denyhosts.cfg').exist?

    sbin.install_symlink libexec+'daemon-control'
    sbin.install_symlink libexec+'denyhosts.py' => 'denyhosts'
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/denyhosts</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>StartInterval</key>
      <integer>600</integer>
    </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    Unless it exists already, a denyhosts.cfg file has been written to:
      #{etc}/denyhosts.cfg

    All DenyHosts scripts will load this file by default unless told to use
    a different one.
    EOS
  end
end

__END__
diff --git a/daemon-control b/daemon-control
new file mode 100755
index 0000000..3e38437
--- /dev/null
+++ b/daemon-control
@@ -0,0 +1,156 @@
+#!/usr/bin/env python
+# denyhosts     Bring up/down the DenyHosts daemon
+#
+# chkconfig: 2345 98 02
+# description: Activates/Deactivates the
+#    DenyHosts daemon to block ssh attempts
+#
+###############################################
+
+###############################################
+#### Edit these to suit your configuration ####
+###############################################
+
+DENYHOSTS_BIN   = "/usr/local/sbin/denyhosts"
+DENYHOSTS_LOCK  = "/usr/local/var/run/denyhosts.pid"
+DENYHOSTS_CFG   = "/usr/local/etc/denyhosts.cfg"
+
+PYTHON_BIN      = "/usr/bin/env python"
+
+###############################################
+####         Do not edit below             ####
+###############################################
+
+DENYHOSTS_BIN = "%s %s" % (PYTHON_BIN, DENYHOSTS_BIN)
+
+import os, sys, signal, time
+
+# make sure 'ps' command is accessible (which should be
+# in either /usr/bin or /bin.  Modify the PATH so
+# popen can find it
+env = os.environ.get('PATH', "")
+os.environ['PATH'] = "/usr/bin:/bin:%s" % env
+
+STATE_NOT_RUNNING = -1
+STATE_LOCK_EXISTS = -2
+
+def usage():
+    print "Usage: %s {start [args...] | stop | restart [args...] | status | debug | condrestart [args...] }" % sys.argv[0]
+    print
+    print "For a list of valid 'args' refer to:"
+    print "$ denyhosts.py --help"
+    print
+    sys.exit(0) 
+
+
+def getpid():
+    try:
+        fp = open(DENYHOSTS_LOCK, "r")
+        pid = int(fp.readline().rstrip())
+        fp.close()
+    except Exception, e:
+        return STATE_NOT_RUNNING
+
+    
+    if not sys.platform.startswith('freebsd') and os.access("/proc", os.F_OK):
+        # proc filesystem exists, look for pid
+        if os.access(os.path.join("/proc", str(pid)), os.F_OK):
+            return pid
+        else:
+            return STATE_LOCK_EXISTS
+    else:
+        # proc filesystem doesn't exist (or it doesn't contain PIDs), use 'ps'
+        p = os.popen("ps -p %d" % pid, "r")
+        p.readline() # get the header line
+        pid_running = p.readline() 
+        # pid_running will be '' if no process is found
+        if pid_running: 
+            return pid
+        else: 
+            return STATE_LOCK_EXISTS
+
+
+def start(*args):
+    cmd = "%s --daemon " % DENYHOSTS_BIN
+    if args: cmd += ' '.join(args)
+        
+    print "starting DenyHosts:   ", cmd
+
+    os.system(cmd)
+
+
+def stop():
+    pid = getpid()
+    if pid >= 0:
+        os.kill(pid, signal.SIGTERM)
+        print "sent DenyHosts SIGTERM"
+    else:
+        print "DenyHosts is not running"
+
+def debug():
+    pid = getpid()
+    if pid >= 0:
+        os.kill(pid, signal.SIGUSR1)
+        print "sent DenyHosts SIGUSR1"
+    else:
+        print "DenyHosts is not running"
+        
+def status():
+    pid = getpid()
+    if pid == STATE_LOCK_EXISTS:
+        print "%s exists but DenyHosts is not running" % DENYHOSTS_LOCK
+    elif pid == STATE_NOT_RUNNING:
+        print "Denyhosts is not running"
+    else:
+        print "DenyHosts is running with pid = %d" % pid
+
+
+def condrestart(*args):
+    pid = getpid()
+    if pid >= 0:
+        restart(*args)
+        
+
+def restart(*args):
+    stop()
+    time.sleep(1)
+    start(*args)  
+
+
+if __name__ == '__main__':
+    cases = {'start':       start,
+             'stop':        stop,
+             'debug':       debug,
+             'status':      status,
+             'condrestart': condrestart,
+             'restart':     restart}
+    
+    try:
+        args = sys.argv[2:]
+    except:
+        args = []
+
+    try:
+        # arg 1 should contain one of the cases above
+        option = sys.argv[1]
+    except:
+        # try to infer context (from an /etc/init.d/ script, perhaps)
+        procname = os.path.basename(sys.argv[0])
+        infer_dict = {'K': 'stop',
+                      'S': 'start'}
+        option = infer_dict.get(procname[0])
+        if not option:
+            usage()
+
+    try:
+        if option in ('start', 'restart', 'condrestart'):
+            if '--config' not in args and '-c' not in args:
+                args.append("--config=%s" % DENYHOSTS_CFG)
+
+        cmd = cases[option]
+        apply(cmd, args)
+    except:
+        usage()
+    
+
+
diff --git a/denyhosts.cfg b/denyhosts.cfg
new file mode 100644
index 0000000..a140844
--- /dev/null
+++ b/denyhosts.cfg
@@ -0,0 +1,620 @@
+       ############ THESE SETTINGS ARE REQUIRED ############
+
+########################################################################
+#
+# SECURE_LOG: the log file that contains sshd logging info
+# if you are not sure, grep "sshd:" /var/log/*
+#
+# The file to process can be overridden with the --file command line
+# argument
+#
+# Redhat or Fedora Core:
+# SECURE_LOG = /var/log/secure
+#
+# Mandrake, FreeBSD or OpenBSD: 
+#SECURE_LOG = /var/log/auth.log
+#
+# SuSE:
+#SECURE_LOG = /var/log/messages
+#
+# Mac OS X (v10.4 or greater - 
+#   also refer to:   http://www.denyhosts.net/faq.html#macos
+#SECURE_LOG = /private/var/log/secure.log
+#
+# Mac OS X (v10.3 or earlier):
+SECURE_LOG=/private/var/log/system.log
+#
+########################################################################
+
+########################################################################
+#
+# HOSTS_DENY: the file which contains restricted host access information
+#
+# Most operating systems:
+HOSTS_DENY = /etc/hosts.deny
+#
+# Some BSD (FreeBSD) Unixes:
+#HOSTS_DENY = /etc/hosts.allow
+#
+# Another possibility (also see the next option):
+#HOSTS_DENY = /etc/hosts.evil
+#######################################################################
+
+
+########################################################################
+#
+# PURGE_DENY: removed HOSTS_DENY entries that are older than this time
+#             when DenyHosts is invoked with the --purge flag
+#
+#      format is: i[dhwmy]
+#      Where 'i' is an integer (eg. 7) 
+#            'm' = minutes
+#            'h' = hours
+#            'd' = days
+#            'w' = weeks
+#            'y' = years
+#
+# never purge:
+PURGE_DENY = 
+#
+# purge entries older than 1 week
+#PURGE_DENY = 1w
+#
+# purge entries older than 5 days
+#PURGE_DENY = 5d
+#######################################################################
+
+#######################################################################
+#
+# PURGE_THRESHOLD: defines the maximum times a host will be purged.  
+# Once this value has been exceeded then this host will not be purged. 
+# Setting this parameter to 0 (the default) disables this feature.
+#
+# default: a denied host can be purged/re-added indefinitely
+#PURGE_THRESHOLD = 0
+#
+# a denied host will be purged at most 2 times. 
+#PURGE_THRESHOLD = 2 
+#
+#######################################################################
+
+
+#######################################################################
+#
+# BLOCK_SERVICE: the service name that should be blocked in HOSTS_DENY
+# 
+# man 5 hosts_access for details
+#
+# eg.   sshd: 127.0.0.1  # will block sshd logins from 127.0.0.1
+#
+# To block all services for the offending host:
+BLOCK_SERVICE = ALL
+# To block only sshd:
+# BLOCK_SERVICE  = sshd
+# To only record the offending host and nothing else (if using
+# an auxilary file to list the hosts).  Refer to: 
+# http://denyhosts.sourceforge.net/faq.html#aux
+#BLOCK_SERVICE =    
+#
+#######################################################################
+
+
+#######################################################################
+#
+# DENY_THRESHOLD_INVALID: block each host after the number of failed login 
+# attempts has exceeded this value.  This value applies to invalid
+# user login attempts (eg. non-existent user accounts)
+#
+DENY_THRESHOLD_INVALID = 5
+#
+#######################################################################
+
+#######################################################################
+#
+# DENY_THRESHOLD_VALID: block each host after the number of failed 
+# login attempts has exceeded this value.  This value applies to valid
+# user login attempts (eg. user accounts that exist in /etc/passwd) except
+# for the "root" user
+#
+DENY_THRESHOLD_VALID = 10
+#
+#######################################################################
+
+#######################################################################
+#
+# DENY_THRESHOLD_ROOT: block each host after the number of failed 
+# login attempts has exceeded this value.  This value applies to 
+# "root" user login attempts only.
+#
+DENY_THRESHOLD_ROOT = 1
+#
+#######################################################################
+
+
+#######################################################################
+#
+# DENY_THRESHOLD_RESTRICTED: block each host after the number of failed 
+# login attempts has exceeded this value.  This value applies to 
+# usernames that appear in the WORK_DIR/restricted-usernames file only.
+#
+DENY_THRESHOLD_RESTRICTED = 1
+#
+#######################################################################
+
+
+#######################################################################
+#
+# WORK_DIR: the path that DenyHosts will use for writing data to
+# (it will be created if it does not already exist).  
+#
+# Note: it is recommended that you use an absolute pathname
+# for this value (eg. /home/foo/denyhosts/data)
+#
+WORK_DIR = /usr/local/var/denyhosts
+#
+#######################################################################
+
+#######################################################################
+#
+# SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS
+#
+# SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS=YES|NO
+# If set to YES, if a suspicious login attempt results from an allowed-host
+# then it is considered suspicious.  If this is NO, then suspicious logins 
+# from allowed-hosts will not be reported.  All suspicious logins from 
+# ip addresses that are not in allowed-hosts will always be reported.
+#
+SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS=YES
+######################################################################
+
+######################################################################
+#
+# HOSTNAME_LOOKUP
+#
+# HOSTNAME_LOOKUP=YES|NO
+# If set to YES, for each IP address that is reported by Denyhosts,
+# the corresponding hostname will be looked up and reported as well
+# (if available).
+#
+HOSTNAME_LOOKUP=YES
+#
+######################################################################
+
+
+######################################################################
+#
+# LOCK_FILE
+#
+# LOCK_FILE=/path/denyhosts
+# If this file exists when DenyHosts is run, then DenyHosts will exit
+# immediately.  Otherwise, this file will be created upon invocation
+# and deleted upon exit.  This ensures that only one instance is
+# running at a time.
+#
+# Redhat/Fedora:
+#LOCK_FILE = /var/lock/subsys/denyhosts
+#
+# Debian
+#LOCK_FILE = /var/run/denyhosts.pid
+#
+# Misc
+LOCK_FILE = /usr/local/var/run/denyhosts.pid
+#
+######################################################################
+
+
+       ############ THESE SETTINGS ARE OPTIONAL ############
+
+
+#######################################################################
+#
+# ADMIN_EMAIL: if you would like to receive emails regarding newly
+# restricted hosts and suspicious logins, set this address to 
+# match your email address.  If you do not want to receive these reports
+# leave this field blank (or run with the --noemail option)
+#
+# Multiple email addresses can be delimited by a comma, eg:
+# ADMIN_EMAIL = foo@bar.com, bar@foo.com, etc@foobar.com
+#
+ADMIN_EMAIL = 
+#
+#######################################################################
+
+#######################################################################
+#
+# SMTP_HOST and SMTP_PORT: if DenyHosts is configured to email 
+# reports (see ADMIN_EMAIL) then these settings specify the 
+# email server address (SMTP_HOST) and the server port (SMTP_PORT)
+# 
+#
+SMTP_HOST = localhost
+SMTP_PORT = 25
+#
+#######################################################################
+
+#######################################################################
+# 
+# SMTP_USERNAME and SMTP_PASSWORD: set these parameters if your 
+# smtp email server requires authentication
+#
+#SMTP_USERNAME=foo
+#SMTP_PASSWORD=bar
+#
+######################################################################
+
+#######################################################################
+#
+# SMTP_FROM: you can specify the "From:" address in messages sent
+# from DenyHosts when it reports thwarted abuse attempts
+#
+SMTP_FROM = DenyHosts <nobody@localhost>
+#
+#######################################################################
+
+#######################################################################
+#
+# SMTP_SUBJECT: you can specify the "Subject:" of messages sent
+# by DenyHosts when it reports thwarted abuse attempts
+SMTP_SUBJECT = DenyHosts Report
+#
+######################################################################
+
+######################################################################
+#
+# SMTP_DATE_FORMAT: specifies the format used for the "Date:" header
+# when sending email messages.
+#
+# for possible values for this parameter refer to: man strftime
+#
+# the default:
+#
+#SMTP_DATE_FORMAT = %a, %d %b %Y %H:%M:%S %z
+#
+######################################################################
+
+######################################################################
+#
+# SYSLOG_REPORT
+#
+# SYSLOG_REPORT=YES|NO
+# If set to yes, when denied hosts are recorded the report data
+# will be sent to syslog (syslog must be present on your system).
+# The default is: NO
+#
+#SYSLOG_REPORT=NO
+#
+#SYSLOG_REPORT=YES
+#
+######################################################################
+
+######################################################################
+#
+# ALLOWED_HOSTS_HOSTNAME_LOOKUP
+#
+# ALLOWED_HOSTS_HOSTNAME_LOOKUP=YES|NO
+# If set to YES, for each entry in the WORK_DIR/allowed-hosts file,
+# the hostname will be looked up.  If your versions of tcp_wrappers
+# and sshd sometimes log hostnames in addition to ip addresses
+# then you may wish to specify this option.
+# 
+#ALLOWED_HOSTS_HOSTNAME_LOOKUP=NO
+#
+######################################################################
+
+###################################################################### 
+# 
+# AGE_RESET_VALID: Specifies the period of time between failed login
+# attempts that, when exceeded will result in the failed count for 
+# this host to be reset to 0.  This value applies to login attempts 
+# to all valid users (those within /etc/passwd) with the 
+# exception of root.  If not defined, this count will never
+# be reset.
+#
+# See the comments in the PURGE_DENY section (above) 
+# for details on specifying this value or for complete details 
+# refer to:  http://denyhosts.sourceforge.net/faq.html#timespec
+#
+AGE_RESET_VALID=5d
+#
+######################################################################
+
+###################################################################### 
+# 
+# AGE_RESET_ROOT: Specifies the period of time between failed login
+# attempts that, when exceeded will result in the failed count for 
+# this host to be reset to 0.  This value applies to all login 
+# attempts to the "root" user account.  If not defined,
+# this count will never be reset.
+#
+# See the comments in the PURGE_DENY section (above) 
+# for details on specifying this value or for complete details 
+# refer to:  http://denyhosts.sourceforge.net/faq.html#timespec
+#
+AGE_RESET_ROOT=25d
+#
+######################################################################
+
+###################################################################### 
+# 
+# AGE_RESET_RESTRICTED: Specifies the period of time between failed login
+# attempts that, when exceeded will result in the failed count for 
+# this host to be reset to 0.  This value applies to all login 
+# attempts to entries found in the WORK_DIR/restricted-usernames file.  
+# If not defined, the count will never be reset.
+#
+# See the comments in the PURGE_DENY section (above) 
+# for details on specifying this value or for complete details 
+# refer to:  http://denyhosts.sourceforge.net/faq.html#timespec
+#
+AGE_RESET_RESTRICTED=25d
+#
+######################################################################
+
+
+###################################################################### 
+# 
+# AGE_RESET_INVALID: Specifies the period of time between failed login
+# attempts that, when exceeded will result in the failed count for 
+# this host to be reset to 0.  This value applies to login attempts 
+# made to any invalid username (those that do not appear 
+# in /etc/passwd).  If not defined, count will never be reset.
+#
+# See the comments in the PURGE_DENY section (above) 
+# for details on specifying this value or for complete details 
+# refer to:  http://denyhosts.sourceforge.net/faq.html#timespec
+#
+AGE_RESET_INVALID=10d
+#
+######################################################################
+
+
+######################################################################
+#
+# RESET_ON_SUCCESS: If this parameter is set to "yes" then the
+# failed count for the respective ip address will be reset to 0
+# if the login is successful.  
+#
+# The default is RESET_ON_SUCCESS = no
+#
+#RESET_ON_SUCCESS = yes
+#
+#####################################################################
+
+
+######################################################################
+#
+# PLUGIN_DENY: If set, this value should point to an executable
+# program that will be invoked when a host is added to the
+# HOSTS_DENY file.  This executable will be passed the host
+# that will be added as it's only argument.
+#
+#PLUGIN_DENY=/usr/bin/true
+#
+######################################################################
+
+
+######################################################################
+#
+# PLUGIN_PURGE: If set, this value should point to an executable
+# program that will be invoked when a host is removed from the
+# HOSTS_DENY file.  This executable will be passed the host
+# that is to be purged as it's only argument.
+#
+#PLUGIN_PURGE=/usr/bin/true
+#
+######################################################################
+
+######################################################################
+#
+# USERDEF_FAILED_ENTRY_REGEX: if set, this value should contain
+# a regular expression that can be used to identify additional
+# hackers for your particular ssh configuration.  This functionality
+# extends the built-in regular expressions that DenyHosts uses.
+# This parameter can be specified multiple times.
+# See this faq entry for more details:
+#    http://denyhosts.sf.net/faq.html#userdef_regex
+#
+#USERDEF_FAILED_ENTRY_REGEX=
+#
+#
+######################################################################
+
+
+
+
+   ######### THESE SETTINGS ARE SPECIFIC TO DAEMON MODE  ##########
+
+
+
+#######################################################################
+#
+# DAEMON_LOG: when DenyHosts is run in daemon mode (--daemon flag)
+# this is the logfile that DenyHosts uses to report it's status.
+# To disable logging, leave blank.  (default is: /var/log/denyhosts)
+#
+DAEMON_LOG = /usr/local/var/log/denyhosts.log
+#
+# disable logging:
+#DAEMON_LOG = 
+#
+######################################################################
+
+#######################################################################
+# 
+# DAEMON_LOG_TIME_FORMAT: when DenyHosts is run in daemon mode 
+# (--daemon flag) this specifies the timestamp format of 
+# the DAEMON_LOG messages (default is the ISO8061 format:
+# ie. 2005-07-22 10:38:01,745)
+#
+# for possible values for this parameter refer to: man strftime
+#
+# Jan 1 13:05:59   
+#DAEMON_LOG_TIME_FORMAT = %b %d %H:%M:%S
+#
+# Jan 1 01:05:59 
+#DAEMON_LOG_TIME_FORMAT = %b %d %I:%M:%S
+#
+###################################################################### 
+
+#######################################################################
+# 
+# DAEMON_LOG_MESSAGE_FORMAT: when DenyHosts is run in daemon mode 
+# (--daemon flag) this specifies the message format of each logged
+# entry.  By default the following format is used:
+#
+# %(asctime)s - %(name)-12s: %(levelname)-8s %(message)s
+#
+# Where the "%(asctime)s" portion is expanded to the format
+# defined by DAEMON_LOG_TIME_FORMAT
+#
+# This string is passed to python's logging.Formatter contstuctor.
+# For details on the possible format types please refer to:
+# http://docs.python.org/lib/node357.html
+#
+# This is the default:
+#DAEMON_LOG_MESSAGE_FORMAT = %(asctime)s - %(name)-12s: %(levelname)-8s %(message)s
+#
+#
+###################################################################### 
+
+ 
+#######################################################################
+#
+# DAEMON_SLEEP: when DenyHosts is run in daemon mode (--daemon flag)
+# this is the amount of time DenyHosts will sleep between polling
+# the SECURE_LOG.  See the comments in the PURGE_DENY section (above)
+# for details on specifying this value or for complete details
+# refer to:    http://denyhosts.sourceforge.net/faq.html#timespec
+# 
+#
+DAEMON_SLEEP = 30s
+#
+#######################################################################
+
+#######################################################################
+#
+# DAEMON_PURGE: How often should DenyHosts, when run in daemon mode,
+# run the purge mechanism to expire old entries in HOSTS_DENY
+# This has no effect if PURGE_DENY is blank.
+#
+DAEMON_PURGE = 1h
+#
+#######################################################################
+
+
+   #########   THESE SETTINGS ARE SPECIFIC TO     ##########
+   #########       DAEMON SYNCHRONIZATION         ##########
+
+
+#######################################################################
+#
+# Synchronization mode allows the DenyHosts daemon the ability
+# to periodically send and receive denied host data such that 
+# DenyHosts daemons worldwide can automatically inform one
+# another regarding banned hosts.   This mode is disabled by
+# default, you must uncomment SYNC_SERVER to enable this mode.
+#
+# for more information, please refer to: 
+#        http:/denyhosts.sourceforge.net/faq.html#sync 
+#
+#######################################################################
+
+
+#######################################################################
+#
+# SYNC_SERVER: The central server that communicates with DenyHost
+# daemons.  Currently, denyhosts.net is the only available server
+# however, in the future, it may be possible for organizations to
+# install their own server for internal network synchronization
+#
+# To disable synchronization (the default), do nothing. 
+#
+# To enable synchronization, you must uncomment the following line:
+#SYNC_SERVER = http://xmlrpc.denyhosts.net:9911
+#
+#######################################################################
+
+#######################################################################
+#
+# SYNC_INTERVAL: the interval of time to perform synchronizations if
+# SYNC_SERVER has been uncommented.  The default is 1 hour.
+# 
+#SYNC_INTERVAL = 1h
+#
+#######################################################################
+
+
+#######################################################################
+#
+# SYNC_UPLOAD: allow your DenyHosts daemon to transmit hosts that have
+# been denied?  This option only applies if SYNC_SERVER has
+# been uncommented.
+# The default is SYNC_UPLOAD = yes
+#
+#SYNC_UPLOAD = no
+#SYNC_UPLOAD = yes
+#
+#######################################################################
+
+
+#######################################################################
+#
+# SYNC_DOWNLOAD: allow your DenyHosts daemon to receive hosts that have
+# been denied by others?  This option only applies if SYNC_SERVER has
+# been uncommented.
+# The default is SYNC_DOWNLOAD = yes
+#
+#SYNC_DOWNLOAD = no
+#SYNC_DOWNLOAD = yes
+#
+#
+#
+#######################################################################
+
+#######################################################################
+#
+# SYNC_DOWNLOAD_THRESHOLD: If SYNC_DOWNLOAD is enabled this parameter
+# filters the returned hosts to those that have been blocked this many
+# times by others.  That is, if set to 1, then if a single DenyHosts
+# server has denied an ip address then you will receive the denied host.
+# 
+# See also SYNC_DOWNLOAD_RESILIENCY
+#
+#SYNC_DOWNLOAD_THRESHOLD = 10
+#
+# The default is SYNC_DOWNLOAD_THRESHOLD = 3 
+#
+#SYNC_DOWNLOAD_THRESHOLD = 3
+#
+#######################################################################
+
+#######################################################################
+#
+# SYNC_DOWNLOAD_RESILIENCY:  If SYNC_DOWNLOAD is enabled then the
+# value specified for this option limits the downloaded data
+# to this resiliency period or greater.
+#
+# Resiliency is defined as the timespan between a hackers first known 
+# attack and it's most recent attack.  Example:
+# 
+# If the centralized   denyhosts.net server records an attack at 2 PM 
+# and then again at 5 PM, specifying a SYNC_DOWNLOAD_RESILIENCY = 4h 
+# will not download this ip address.
+#
+# However, if the attacker is recorded again at 6:15 PM then the 
+# ip address will be downloaded by your DenyHosts instance.  
+#
+# This value is used in conjunction with the SYNC_DOWNLOAD_THRESHOLD 
+# and only hosts that satisfy both values will be downloaded.  
+# This value has no effect if SYNC_DOWNLOAD_THRESHOLD = 1 
+#
+# The default is SYNC_DOWNLOAD_RESILIENCY = 5h (5 hours)
+#
+# Only obtain hackers that have been at it for 2 days or more:
+#SYNC_DOWNLOAD_RESILIENCY = 2d
+#
+# Only obtain hackers that have been at it for 5 hours or more:
+#SYNC_DOWNLOAD_RESILIENCY = 5h
+#
+#######################################################################
+
