require 'formula'

class PrivoxyBlocklist < Formula
  homepage 'http://andrwe.org/scripting/bash/privoxy-blocklist'
  url 'https://github.com/Andrwe/privoxy-blocklist.git', :release => 'e414ad7057'
  head 'https://github.com/Andrwe/privoxy-blocklist'
  version '0.3'

  depends_on 'privoxy'

  def install
    # Define default English-language filter subscriptions.
    lists = %w(
      https://easylist-downloads.adblockplus.org/easylist.txt
      https://easylist-downloads.adblockplus.org/easyprivacy.txt
      https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
      https://easylist-downloads.adblockplus.org/fanboy-social.txt
    )

    # Fix privoxy-blocklist for Mac OS X.
    inreplace "privoxy-blocklist.sh" do |s|
      s.gsub! '[ ${UID} -ne 0 ]', '[ ! -w "$(dirname ${SCRIPTCONF})" ]'
      s.gsub! 'SCRIPTCONF=/etc/conf.d/privoxy-blacklist', "SCRIPTCONF=#{etc}/privoxy/blocklist"
      s.gsub! 'INIT_CONF=\"/etc/conf.d/privoxy\"', "#INIT_CONF=\\\"#{etc}/privoxy\\\""
      s.gsub! '#PRIVOXY_USER=\"privoxy\"', "PRIVOXY_USER=\\\"#{Process.uid}\\\""
      s.gsub! '#PRIVOXY_GROUP=\"privoxy\"', "PRIVOXY_GROUP=\\\"#{Process.gid}\\\""
      s.gsub! '#PRIVOXY_CONF=\"/etc/privoxy/config\"', "PRIVOXY_CONF=\\\"#{etc}/privoxy/config\\\""
      s.gsub! 'wget', 'curl'
      s.gsub! '-t 3 --no-check-certificate -O', '--retry 3 --insecure --output'
      s.gsub! /URLS=\([^)]+\)/, "URLS=(\\\"#{lists.join('\" \"')}\\\")"
    end

    # Install the script with the extension removed.
    sbin.install "privoxy-blocklist.sh" => "privoxy-blocklist"

    # Prepend Privoxy's sbin directory to PATH since Homebrew fails to do so.
    ENV.prepend_path "PATH", Formula.factory('privoxy').sbin

    # Generate the configuration file.
    #
    # It returns a non-zero value when there is no configuration file and has
    # to generate it. This, in turn, causes Homebrew to think that the
    # installation has failed. Thus, use backticks instead of system to execute
    # the script.
    `#{sbin}/privoxy-blocklist`
  end

  test do
    system "#{sbin}/privoxy-blocklist", "--help"
  end
  
  def caveats; <<-EOS.undent
    This formula pre-installs English-language Adblock subscriptions.
    Subscribe to additional filter lists from the following URLs:

        https://adblockplus.org/en/subscriptions
        https://easylist.adblockplus.org/en

    Then paste the subscription URL inside of the `URLS` array in:

        #{etc}/privoxy/blocklist
    
    Execute privoxy-blocklist after subscribing to a new filter list or to 
    update currently subscribed filter lists:
        
        #{sbin}/privoxy-blocklist
   
    Privoxy does not need to be made aware of configuration file changes by
    signaling SIGHUP; it detects changes automatically. 
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/sbin/privoxy-blocklist</string>
        </array>
        <key>Nice</key>
        <integer>20</integer>
        <key>StartInterval</key>
        <integer>604800</integer>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/privoxy/blocklist-error.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/privoxy/blocklist.log</string>
      </dict>
    </plist>
    EOS
  end
end
