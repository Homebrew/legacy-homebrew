require 'formula'

class AtlassianPluginSdk <Formula
  url 'https://maven.atlassian.com/public/com/atlassian/amps/atlassian-plugin-sdk/3.2.4/atlassian-plugin-sdk-3.2.4.tar.gz'
  homepage 'http://confluence.atlassian.com/display/DEVNET/Setting+up+your+Plugin+Development+Environment'
  md5 '67d98f8b490714adbaf30a59d348eb72'

def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ apache-maven/maven-docs/NOTICE.txt apache-maven/maven-docs/LICENSE.txt apache-maven/maven-docs/README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end

    ohai 'Congratulations for installing the Atlassian Plugin SDK!'
    ohai '# Create a plugin skeleton using atlas-create-APPLICATION-plugin, e.g. atlas-create-confluence-plugin.'
    ohai '# Run your plugin\'s host application with the plugin skeleton installed, using atlas-run.'
  end

end
