require 'formula'

class Storm < Formula
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.5.3.zip'
  homepage 'https://github.com/nathanmarz/storm'
  md5 '8bd6cc96052eb5961ba119e24875dc6b'

  def install
    prefix.install Dir["{bin,lib,log4j,logs,public}"]
    prefix.install Dir["*.jar"]
    mkdir_p File.expand_path("~/.storm")
    cp_r Dir["conf/*"], File.expand_path("~/.storm") unless File.exist?(File.expand_path("~/.storm/storm.yaml"))
    
    inreplace "#{prefix}/bin/storm", 'STORM_DIR = "/".join(os.path.abspath( __file__ ).split("/")[:-2])', "STORM_DIR = \"#{prefix}\""
  end
  
  def caveats; <<-EOS
Storm has been installed to #{prefix}.

Configuration has been copied to ~/.storm

Please edit ~/.storm/storm.yaml to specify your production storm
configuration.
EOS
  end
end
