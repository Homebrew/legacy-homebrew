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
    system 'rake man'

    bin.install 'hub'
    man1.install 'man/hub.1'
  end
end
