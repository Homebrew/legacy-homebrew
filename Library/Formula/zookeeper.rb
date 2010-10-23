require 'formula'

class Zookeeper <Formula
  url 'http://mirror.switch.ch/mirror/apache/dist/hadoop/zookeeper/zookeeper-3.3.1/zookeeper-3.3.1.tar.gz'
  homepage 'http://hadoop.apache.org/zookeeper'
  md5 'bdcd73634e3f6623a025854f853c3d0d'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      . "#{etc}/zookeeper/defaults"
      cd #{libexec}/bin
      ./#{target} $*
    EOS
  end

  def default_zk_env
    <<-EOS.undent
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def default_log4j_properties
    <<-EOS.undent
      log4j.rootCategory=WARN, zklog

      log4j.appender.zklog = org.apache.log4j.FileAppender
      log4j.appender.zklog.File = #{var}/log/zookeeper/zookeeper.log
      log4j.appender.zklog.Append = true
      log4j.appender.zklog.layout = org.apache.log4j.PatternLayout
      log4j.appender.zklog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
    EOS
  end

  def install
    # Remove windows executables
    rm_f Dir["bin/*.cmd"]

    # Install Java stuff
    libexec.install %w(bin contrib lib)
    libexec.install Dir['*.jar']

    # Create neccessary directories
    bin.mkpath
    (etc+'zookeeper').mkpath
    (var+'log/zookeeper').mkpath
    (var+'run/zookeeper/data').mkpath

    # Install shim scripts to bin
    Dir["#{libexec}/bin/*.sh"].map { |p| Pathname.new p }.each { |path|
      next if path == libexec+'bin/zkEnv.sh'
      script_name = path.basename
      bin_name    = path.basename '.sh'
      (bin+bin_name).write shim_script(script_name)
    }

    # Install default config files
    defaults = etc+'zookeeper/defaults'
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc+'zookeeper/log4j.properties'
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    unless (etc+'zookeeper/zoo.cfg').exist?
      inreplace 'conf/zoo_sample.cfg', /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
      (etc+'zookeeper').install 'conf/zoo_sample.cfg'
    end
  end
end
