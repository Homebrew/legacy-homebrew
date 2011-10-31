require 'formula'

class AtlassianPluginSdk < Formula
  url 'https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/amps/atlassian-plugin-sdk/3.6.2/atlassian-plugin-sdk-3.6.2.tar.gz'
  homepage 'https://developer.atlassian.com/display/DOCS/Atlassian+Plugin+SDK+Documentation'
  md5 '0a642400ea619420b2faae290688e6a1'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    Dir.chdir "apache-maven/maven-docs" do
      prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    end

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end

  end

  def caveats
    <<-EOS.undent
      Thanks for installing the Atlassian Plugin SDK. For more information,
      visit https://developer.atlassian.com.

      To create a plugin skeleton using atlas-create-APPLICATION-plugin, e.g.:
        atlas-create-jira-plugin

      To run your plugin's host application with the plugin skeleton installed:
        atlas-run
    EOS
  end
end
