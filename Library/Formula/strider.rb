class UniversalNpm < Requirement
  fatal true
  satisfy { which("npm") }
  def message
    "npm is required. If you have installed node with `--without-npm` option, reinstall with `--with-npm`."
  end
end

class UniversalNode < Requirement
  fatal true
  satisfy { which("node") }
  def message
    "node is required. You can install this via nvm or by a straightforward `brew install node`."
  end
end

class Strider < Formula
  url "https://github.com/Strider-CD/strider/archive/v1.6.3.tar.gz"
  sha1 "6f0fe2b306e2bce395d39b9ce2dc6249bdcf616d"
  homepage "http://stridercd.com/"

  depends_on UniversalNode
  depends_on UniversalNpm
  depends_on "mongodb"

  head "https://github.com/Strider-CD/strider.git", :branch => "develop"

  def install
    system "npm", "install", "-g"

    if File.file?(etc/"striderrc")
      ohai "Existing config file found at #{HOMEBREW_PREFIX}/etc/striderrc"
    else
      (etc/"striderrc").write conf_file
      ohai "The strider config file has been installed to #{HOMEBREW_PREFIX}/etc/striderrc. Please modify this after the installation."
    end
  end

  def caveats
    "If this is a clean install, you will need to add an admin user. To do so, execute 'strider addUser' and follow the prompts."
  end

  def conf_file; <<-EOS.undent
      {
        "host"        : "0.0.0.0",
        "port"        : 3000,
        "server_name" : "http://localhost",
        "db_uri"      : "mongodb://localhost/strider-foss",
        "smtp_host" : "",
        "smtp_port" : 587,
        "smtp_user" : "",
        "smtp_pass" : "",
        "smtp_from" : "Strider <noreply@stridercd.com>",
        "enablePty"      : false,
        "extpath"        : "node_modules",
        "session_secret" : "8L8BudMkqBUqrz",
        "github_app_id"  : "",
        "github_secret"  : "",
        "cors"           : false
      }
    EOS
  end

  plist_options :manual => "strider --config #{HOMEBREW_PREFIX}/etc/striderrc"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>        <string>#{plist_name}</string>
        <key>RunAtLoad</key>    <true/>
        <key>KeepAlive</key>    <true/>
        <key>ProgramArguments</key>
        <array>
          <string>node</string>
          <string>strider</string>
          <string>--config #{HOMEBREW_PREFIX}/etc/striderrc</string>
          <string>STRIDER_CLONE_DEST=~/.strider/builds/</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/strider.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/strider.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "strider", "-v"
  end
end
