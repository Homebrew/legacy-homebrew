require 'formula'

class Kismet <Formula
  url 'http://www.kismetwireless.net/code/kismet-2010-07-R1.tar.gz'
  version '2010-07-R1'
  homepage 'http://www.kismetwireless.net'
  sha256 'b1bae7a97e7a904bf620f285aa0d62ebc1fd3b54b671fbca125405036f949e80'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--sysconfdir=#{etc}"

    # Don't chown anything.
    inreplace "Makefile", "-o $(INSTUSR) -g $(INSTGRP)", ""
    inreplace "Makefile", "-o $(INSTUSR) -g $(MANGRP)", ""

    system "make install"
    
    # Configure the interface for your systems, requires small plist gem
    require 'rubygems'
    system "gem install plist" if not Gem.available?('plist')
    addInterfacesToConfig()
  end

  def caveats
    <<-EOS.undent
      Read http://www.kismetwireless.net/documentation.shtml and edit #{etc}/kismet.conf as needed.

      - SUID Root functionality does not work, you will have to run this as root, e.g. via `sudo`. Do so at your own risk.
      - This version can be configured interactively when it is run (listen interface, etc).
      - Automatically configured to use first AirPort interface found
    EOS
  end
  
  def addInterfacesToConfig
    Gem.clear_paths
    require 'plist'
    file = IO.popen('/usr/sbin/system_profiler -detailLevel mini -xml SPNetworkDataType', mode='r')
    sysprof_data = Plist::parse_xml(file)
    airport_interface = sysprof_data[0]['_items'].find_all { |item| item['_name'] == 'AirPort' }[0]['interface']

    kismet_ncsources = "ncsource=%s:name=AirPort" % airport_interface
    open("#{etc}/kismet.conf", 'a') { |f|
      f.puts "# Source interface (auto-added via homebrew installation)"
      f.puts kismet_ncsources
    }
  end
end
