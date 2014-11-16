require 'formula'

class Jmeter < Formula
  homepage 'http://jmeter.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-2.11.tgz'
  sha1 'e9b24f8b5f34565831aafcb046e72bdfa9537386'

  resource "jmeterplugins-standard" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.1.3.zip"
    sha1 "ceec5be5d5aef21f9af3b251637a97fdfde0ffd3"
  end

  resource "serveragent" do
    url "http://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha1 "c8ee7015b10f48acf4664ec33733e0c1eb025cb7"
  end

  resource "jmeterplugins-extras" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.1.3.zip"
    sha1 "b7d74f79c309e50bd01d6fd0d2138eb9d47cb1e7"
  end

  resource "jmeterplugins-extraslibs" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.1.3.zip"
    sha1 "dadeee54854aff2f46efc51f6d89a5bfb541b40f"
  end

  resource "jmeterplugins-webdriver" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.1.3.zip"
    sha1 "5ac53a9d881a2192872d06153a8a212fa3a8ee11"
  end

  resource "jmeterplugins-hadoop" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.1.2.zip"
    sha1 "2d7362ea0e10215647eccd9505c49bb55269be27"
  end

  option "with-plugins", "add JMeterPlugins Standard, Extras, ExtrasLibs, WebDriver and Hadoop"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"

    if build.with? "plugins"
      resource("jmeterplugins-standard").stage do
        rm_f Dir["lib/ext/*.bat"]
        (libexec/"lib/ext").install Dir["lib/ext/*"]
        (libexec/"licenses/plugins/standard").install "LICENSE", "README"
      end
      resource("serveragent").stage do
        rm_f Dir["*.bat"]
        rm_f Dir["lib/*winnt*"]
        rm_f Dir["lib/*solaris*"]
        rm_f Dir["lib/*aix*"]
        rm_f Dir["lib/*hpux*"]
        rm_f Dir["lib/*linux*"]
        rm_f Dir["lib/*freebsd*"]
        (libexec/"serveragent").install Dir["*"]
      end
      resource("jmeterplugins-extras").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-extraslibs").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-webdriver").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-hadoop").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README", "NOTICE"
      end
    end
  end
end
