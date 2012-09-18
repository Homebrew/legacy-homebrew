require 'formula'

class AtlassianPluginSdk < Formula
  homepage 'https://developer.atlassian.com'

  # Get the latest versioned download URL from 
  # https://marketplace.atlassian.com/plugins/atlassian-plugin-sdk-tgz
  url 'https://marketplace.atlassian.com/download/plugins/atlassian-plugin-sdk-tgz/version/25'

  # To generate a sha1 sig on a mac, run
  #   `shasum <sdk.tgz>`
  sha1 'f18ee77fbad58ceca3108ccc271cabcefa23f817'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      Thanks for installing the Atlassian Plugin SDK. For more information,
      visit https://developer.atlassian.com.

      To create a plugin skeleton using atlas-create-APPLICATION-plugin, e.g.:
        atlas-create-jira-plugin or atlas-create-confluence-plugin

      To run your plugin's host application with the plugin skeleton installed:
        atlas-run or atlas-debug

      This Homebrew recipe is maintained by the nice folks at Atlassian Developer Relations @atlassiandev.
    EOS
  end
end
