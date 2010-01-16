require 'formula'

class Hub <Formula
  head 'git://github.com/defunkt/hub.git', :tag => 'v0.1.3'
  homepage 'http://github.com/defunkt/hub'

  def initialize(*args)
    super

    # Force version instead of HEAD
    @version = '0.1.3'
  end

  def install
    system "rake install prefix=#{prefix}"
  end
end
