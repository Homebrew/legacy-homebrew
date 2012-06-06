require 'formula'

class Freenet < Formula
  homepage 'https://freenetproject.org'
  url 'https://freenet.googlecode.com/files/new_installer_offline_1407.jar'
  sha1 '8d631d4764ce4376ee6f021b69863b0ba608874f'
  keg_only "FreeNet is self-contained."

  def install
    @buildpath = Pathname.pwd
    @binpath = HOMEBREW_PREFIX + 'bin/'
    system "echo INSTALL_PATH=#{prefix} > #{buildpath}/__FreeNetinstall__"
    system "java -jar ./new_installer_offline_1407.jar -options #{buildpath}/__FreeNetinstall__"
    @binpath.install_symlink prefix + 'StartFreenet.command'
  end

end
