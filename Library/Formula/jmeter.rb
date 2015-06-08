require 'formula'

class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage 'https://jmeter.apache.org/'
  url 'https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-2.13.tgz'
  sha1 'a7699b1d61b8e6095d6d1b5388a9714a47d568e9'

  resource "jmeterplugins-standard" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.1.zip"
    sha1 "f72a54686b67fbd3bf8b9f505b4e12e7ff16dbf0"
  end

  resource "serveragent" do
    url "http://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha1 "c8ee7015b10f48acf4664ec33733e0c1eb025cb7"
  end

  resource "jmeterplugins-extras" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.2.1.zip"
    sha1 "633167975f3b490a1a22f827a7a2e1b0dcc9ec97"
  end

  resource "jmeterplugins-extraslibs" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.2.1.zip"
    sha1 "5699453db084075fa1a43fe12505c60c1ad562af"
  end

  resource "jmeterplugins-webdriver" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.2.1.zip"
    sha1 "4a138a16de0a1e6363de01c858285d0b96185b74"
  end

  resource "jmeterplugins-hadoop" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.2.1.zip"
    sha1 "52cc0c8985c5faf8cd0b009d0ad2fa3a51fe6a29"
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
