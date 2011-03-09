require 'formula'

class OpenTyrianData <Formula
  url 'http://sites.google.com/a/camanis.net/opentyrian/tyrian/tyrian21.zip'
  md5 '2a3b206a6de25ed4b771af073f8ca904'
end

class OpenTyrian <Formula
  url 'http://opentyrian.googlecode.com/hg/', :revision =>  '9ddcd06e48'
  homepage 'http://code.google.com/p/opentyrian/'
  version '20091122'

  depends_on 'sdl'
  depends_on 'sdl_net'

  def install
    OpenTyrianData.new.brew { libexec.install Dir['*'] }

    system "make release"
    libexec.install "opentyrian"
    # Use a startup script to find the game data
    (bin+'opentyrian').write startup_script
  end

  def startup_script
<<-END
#!/bin/bash
#{libexec}/opentyrian --data=#{libexec} $*
END
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end
end
