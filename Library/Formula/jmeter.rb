require 'formula'

class Jmeter < Formula
  homepage 'http://jmeter.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-2.12.tgz'
  sha1 '2b3de1d1ebc4c85a1fc5da12279649d97ca45788'

  resource "jmeterplugins-standard" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.0.zip"
    sha1 "1700158e5ce23748db5f59b8c5b9b608a345eef7"
  end

  resource "serveragent" do
    url "http://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha1 "c8ee7015b10f48acf4664ec33733e0c1eb025cb7"
  end

  resource "jmeterplugins-extras" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.2.0.zip"
    sha1 "abd19f4befbd2dc992cc41abbb6f8a772b2fb4d6"
  end

  resource "jmeterplugins-extraslibs" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.2.0.zip"
    sha1 "549ec55da3b7a2bcf73b9ceecd0d66c1e7675d53"
  end

  resource "jmeterplugins-webdriver" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.2.0.zip"
    sha1 "6519c05d9cd93d1f44fc733b772f232bb4568846"
  end

  resource "jmeterplugins-hadoop" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.2.0.zip"
    sha1 "83ce7b84349acb40c5f8f63c7bbc8f9eaf38c542"
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
