require 'formula'

class Pidcat < Formula
  homepage 'https://github.com/JakeWharton/pidcat'
  url 'https://github.com/JakeWharton/pidcat.git', :branch => 'master'
  version '1.0.0'

  def install
    bin.install('pidcat.py')
  end

end
