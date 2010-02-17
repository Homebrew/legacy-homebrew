require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v0.3.2'
  homepage 'http://github.com/defunkt/hub'
  md5 'e87f8e0c28232acbec75cb7645548def'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
