require 'formula'

class JdkInstalled < Requirement
  def message; <<-EOS.undent
    A JDK is required.

    You can get the official Oracle installers from:
    http://www.oracle.com/technetwork/java/javase/downloads/index.html
    EOS
  end

  def satisfied?
    which 'javac'
  end

  def fatal?
    true
  end
end

class JavaHome < Requirement
  def message; <<-EOS.undent
    JAVA_HOME is unset. JAVA_HOME is required to build pydoop.
    A JDK is required. If you don't have java installed you can get the official Oracle installers from:
    http://www.oracle.com/technetwork/java/javase/downloads/index.html
    EOS
  end

  def satisfied?
    ENV["JAVA_HOME"]
  end

  def fatal?
    true
  end
end

class Pydoop < Formula
  homepage ''
  url 'http://sourceforge.net/projects/pydoop/files/Pydoop-0.8/pydoop-0.8.1.tar.gz'
  version '0.8.1'
  sha1 '9ef27551b1a16ef0454b903306cf05408ca91e7c'

  depends_on JdkInstalled.new
  depends_on JavaHome.new
  depends_on 'boost'
  depends_on 'hadoop'

  def install
    ENV.append 'HADOOP_HOME', '/usr/local/Cellar/hadoop/1.1.1/libexec'
    ENV.append 'BOOST_PYTHON', 'boost_python-mt'
    system 'python', 'setup.py', 'build'
    system 'python', 'setup.py', 'install', '--user'
  end

  def test
    system "false"
  end
end
