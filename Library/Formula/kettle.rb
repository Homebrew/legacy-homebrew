class Kettle < Formula
  desc "Pentaho Data Integration software"
  homepage "http://community.pentaho.com/projects/data-integration/"
  url "https://downloads.sourceforge.net/project/pentaho/Data%20Integration/5.0.1-stable/pdi-ce-5.0.1-stable.zip"
  sha256 "f669f1aaaf0ef0e453ea64df91e016dac8a8b20e3ba90ede758d2f80dc262855"

  def install
    rm_rf Dir["*.{bat}"]
    libexec.install Dir["*"]

    (etc+"kettle").install libexec+"pwd/carte-config-master-8080.xml" => "carte-config.xml"
    (etc+"kettle/.kettle").install libexec+"pwd/kettle.pwd"
    (etc+"kettle/simple-jndi").mkpath

    (var+"log/kettle").mkpath

    # We don't assume that carte, kitchen or pan are in anyway unique command names so we'll prepend "pdi"
    %w[carte kitchen pan].each do |command|
      (bin+"pdi#{command}").write_env_script libexec+"#{command}.sh", :BASEDIR => libexec
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/pdicarte</string>
          <string>#{etc}/kettle/carte-config.xml</string>
        </array>
        <key>EnvironmentVariables</key>
        <dict>
          <key>KETTLE_HOME</key>
          <string>#{etc}/kettle</string>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{etc}/kettle</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kettle/carte.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kettle/carte.log</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/pdikitchen", "-file=#{libexec}/samples/jobs/Slowly\ Changing\ Dimension/create\ -\ populate\ -\ update\ slowly\ changing\ dimension.kjb", "-level=RowLevel"
    system "#{bin}/pdipan", "-file=#{libexec}/samples/transformations/Encrypt\ Password.ktr", "-level=RowLevel"
  end
end
