require "formula"

class Artifactory < Formula
  homepage "http://www.jfrog.com/artifactory/"
  url "http://dl.bintray.com/jfrog/artifactory/artifactory-3.4.1.zip"
  sha1 "c8ca7a024be33648ab36f5e674f340c6630ec603"

  depends_on :java => "1.7"

  option "with-low-heap", "Run artifactory with low Java memory options. Useful for development machines. Do not use in production."
  option "with-java8", "Adjust memory settings for Java 8"

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Set correct working directory
    inreplace "bin/artifactory.sh",
      'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
      "export ARTIFACTORY_HOME=#{libexec}"

    # Remove obsolete parameters for Java 8
    inreplace "bin/artifactory.default",
      "-server -Xms512m -Xmx2g -Xss256k -XX:PermSize=128m -XX:MaxPermSize=256m -XX:+UseG1GC",
      "-server -Xms512m -Xmx2g -Xss256k -XX:+UseG1GC" if build.with? "java8"

    # Reduce memory consumption for non production use
    inreplace "bin/artifactory.default",
      "-server -Xms512m -Xmx2g",
      "-Xms128m -Xmx768m" if build.with? "low-heap"

    libexec.install Dir["*"]

    # Launch Script
    bin.install_symlink libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install_symlink libexec/"bin/artifactory.default"
  end


  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, I symlink the data dir to var.
    data = (var+"artifactory")
    data.mkpath

    libexec.install_symlink data => "data"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/artifactory/libexec/bin/artifactory.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.jfrog.artifactory</string>

        <key>WorkingDirectory</key>
        <string>#{libexec}</string>

        <key>Program</key>
        <string>bin/artifactory.sh</string>

        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    output = `#{bin}/artifactory.sh check 2>&1`
    assert output.include?("Checking arguments to Artifactory")
    assert_equal 1, $?.exitstatus
  end
end
