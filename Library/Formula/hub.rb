require 'formula'

class Hub <Formula
  head 'git://github.com/defunkt/hub.git', :tag => 'v0.1.2'
  homepage 'http://github.com/defunkt/hub'

  def initialize(*args)
    super

    # Force version instead of HEAD
    @version = '0.1.2'
  end

  def install
    # standalone task runs tests which fail
    # system 'rake standalone'
    system %(ruby -Ilib -rhub -e "Hub::Standalone.save('hub')")
    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.cp 'hub', "#{prefix}/bin/hub"

    system 'rake man'
    FileUtils.mkdir_p "#{prefix}/share/man/man1"
    FileUtils.cp 'man/hub.1', "#{prefix}/share/man/man1"
  end
end
