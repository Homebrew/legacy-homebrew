require 'formula'

class I2p < Formula
  homepage 'http://i2p2.de'
  url 'http://mirror.i2p2.de/i2pinstall_0.9.jar'
  md5 'f6d575caa5e0337c89424cf859d25a36'
  keg_only "I2p is self-contained."

  def install
    @buildpath = Pathname.pwd
    @binpath = HOMEBREW_PREFIX + 'bin/'
    system "echo INSTALL_PATH=#{prefix} > #{buildpath}/__I2pinstall__"
    system "java -jar ./i2pinstall_0.9.jar -options #{buildpath}/__I2Pinstall__"
    system "ln -s #{prefix}/i2psvc-macosx-universal-64 #{prefix}/i2psvc"
    system "mkdir -p #{prefix}/bin"
    system "cp #{prefix}/i2prouter #{prefix}/bin/"
    system "cp #{prefix}/eepget #{prefix}/bin/"
    man1.install Dir[prefix + 'man/*']
    @binpath.install_symlink Dir[prefix + 'bin/*']
  end

end
