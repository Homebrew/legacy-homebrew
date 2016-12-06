require 'formula'

class FreediameterServer < Formula
  homepage 'http://www.freediameter.net'
  url 'http://www.freediameter.net/hg/freeDiameter/archive/1.1.5.tar.gz'
  sha1 'bcbda1683f2d502506478c9916313b25dc73a714'

  option 'with-all-extensions', 'Enable all extensions'

  depends_on 'cmake' => :build
  depends_on 'gnutls'

  if build.include? 'with-all-extensions'
    depends_on :postgresql
    depends_on :mysql
    depends_on 'swig' => :build
  end

  depends_on 'libidn'

  def install

    cmake_args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]

    cmake_args << '-DALL_EXTENSIONS=ON' if build.include? 'with-all-extensions'

    system 'cmake', *cmake_args
    system 'make'
    system 'make install'

    mv 'doc', prefix
    mv 'contrib', prefix

    unless File.exists?(etc/'freeDiameter.conf')
      cp prefix/'doc/freediameter.conf.sample', etc/'freeDiameter.conf'
    end

  end

  def caveats; <<-EOS.undent
    To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

    Sample configuration files can be found in #{prefix}/doc

    For more information about freeDiameter configuration options, read:
      http://www.freediameter.net/trac/wiki/Configuration

    Other potentially usefull files can be found in #{prefix}/contrib

    To load freeDiameter automatically on startup, install and load the provided launchd
    item as follows:

      sudo cp #{plist_path} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}
    EOS
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/bin/freeDiameterd</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
