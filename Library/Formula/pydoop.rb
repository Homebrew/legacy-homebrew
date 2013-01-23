require 'formula'

class JdkInstalled < Requirement
  def message; <<-EOS.undent
    A JDK is required.  You can get the official Oracle installers from:
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
    JAVA_HOME is not set:  please set it to the correct value for your Java
    installation.  For instance:
    /Library/Java/JavaVirtualMachines/jdk1.7.0_11.jdk/Contents/Home
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
  homepage 'http://http://pydoop.sourceforge.net/'
  url 'http://sourceforge.net/projects/pydoop/files/Pydoop-0.8/pydoop-0.8.1.tar.gz'
  sha1 '9ef27551b1a16ef0454b903306cf05408ca91e7c'

  depends_on JdkInstalled.new
  depends_on JavaHome.new
  depends_on 'boost'
  unless(ENV["HADOOP_HOME"])
    depends_on 'hadoop'
  end

  def install
    unless(ENV["HADOOP_HOME"])
      ohai "HADOOP_HOME is not set.  Using brew version"
      ENV.append 'HADOOP_HOME', Formula.factory('hadoop').libexec
    end
    ENV.append 'BOOST_PYTHON', 'boost_python-mt'
    system 'python', 'setup.py', 'build'

    # In order to install into the Cellar, the dir must exist and be in the
    # PYTHONPATH.
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages
    ENV['PYTHONPATH'] = temp_site_packages
    args = [
      "--no-user-cfg",
      "--verbose",
      "install",
      "--force",
      "--install-scripts=#{bin}",
      "--install-lib=#{temp_site_packages}",
      "--install-data=#{share}",
      "--install-headers=#{include}",
      "--record=installed-files.txt"
    ]
    system "python", "-s", "setup.py", *args

    prefix.install %w[test examples]
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    If you use the Homebrew version of Python, you might get a
    "PyThreadState_Get: no current thread" error.  In this case, try
    reinstalling boost with the --build-from-source option.  For
    details, see:
    https://github.com/mxcl/homebrew/wiki/Common-Issues
    EOS
  end

end
