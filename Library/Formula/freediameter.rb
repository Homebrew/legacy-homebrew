require 'formula'

class Freediameter < Formula
  homepage 'http://www.freediameter.net'
  url 'http://www.freediameter.net/hg/freeDiameter/archive/1.1.6.tar.gz'
  sha1 'fac9cf7c4aa8b2b10aaf7f70214f8f808f8e05ab'

  head 'http://www.freediameter.net/hg/freeDiameter', :using => :hg

  option 'with-all-extensions', 'Enable all extensions'

  depends_on 'cmake' => :build
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'libidn'

  if build.include? 'with-all-extensions'
    depends_on :postgresql
    depends_on :mysql
    depends_on 'swig' => :build
  end

  def install

    args = std_cmake_args + %W[
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]

    args << '-DALL_EXTENSIONS=ON' if build.include? 'with-all-extensions'
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make install'
    end

    prefix.install 'doc', 'contrib'

    unless File.exists?(etc/'freeDiameter.conf')
      cp prefix/'doc/freediameter.conf.sample', etc/'freeDiameter.conf'
    end

  end

  def caveats; <<-EOS.undent
    To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

    Sample configuration files can be found in #{prefix}/doc

    For more information about freeDiameter configuration options, read:
      http://www.freediameter.net/trac/wiki/Configuration

    Other potentially useful files can be found in #{prefix}/contrib
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/freeDiameterd</string>
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
