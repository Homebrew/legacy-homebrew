require 'formula'

class Pidcat < Formula
  homepage 'https://github.com/JakeWharton/pidcat'
  url 'https://github.com/JakeWharton/pidcat.git'
  version '1.4.0'

  def install
    bin.install('pidcat.py')
  end

end
