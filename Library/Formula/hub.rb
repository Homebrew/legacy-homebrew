require 'formula'

class Hub <Formula
  head 'git://github.com/defunkt/hub.git', :tag => 'v0.3.0'
  homepage 'http://github.com/defunkt/hub'

  def initialize(*args)
    super

    # Force version instead of HEAD
    @version = '0.3.0'
  end

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
