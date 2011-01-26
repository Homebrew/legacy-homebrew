require 'formula'

class Glassfish <Formula
  url 'http://download.java.net/glassfish/3.0.1/release/glassfish-3.0.1.zip'
  homepage 'http://glassfish.java.net/'
  md5 'a24f6ca15bb6b38d4cb2998d607abcde'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def install
    # Remove Windows files
    rm Dir['glassfish/bin/*.{bat,dll,exe}']
    libexec.install Dir['glassfish/*']
    (bin+'glassfish-startserv').write startup_script('startserv')
    (bin+'glassfish-stopserv').write startup_script('stopserv')
  end
end
