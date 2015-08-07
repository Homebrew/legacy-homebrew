class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-2.13.tgz"
  sha256 "9fe33d3d6e381103d3ced2962cdef5c164a06fc58c55e247eadf5a5dbcd4d8fe"

  resource "jmeterplugins-standard" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.1.zip"
    sha256 "196948e10762f446c00f5e5ba89e474e933d270eff4d79a842b15e8ffb8cfb87"
  end

  resource "serveragent" do
    url "http://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha256 "2d5cfd6d579acfb89bf16b0cbce01c8817cba52ab99b3fca937776a72a8f95ec"
  end

  resource "jmeterplugins-extras" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.2.1.zip"
    sha256 "7d19e0b7a99fdc71db93a37383202e91a73f89fab59b0a87636b4c00436b9aa0"
  end

  resource "jmeterplugins-extraslibs" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.2.1.zip"
    sha256 "b32b9f96d93130250764868c5302def04c73db6466cb50c5834c0ab5c62a5557"
  end

  resource "jmeterplugins-webdriver" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.2.1.zip"
    sha256 "2bd0066e4c6a5e60eeb72566ea3cdb618e5c7ed02e3f3fd1b9ed1571c9a0b5ff"
  end

  resource "jmeterplugins-hadoop" do
    url "http://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.2.1.zip"
    sha256 "2192cab0b4ce7a07c317647ddf9c6458d2ff2587288430f6707d173c49baf4e9"
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
