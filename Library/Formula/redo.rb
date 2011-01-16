require 'formula'

class Redo <Formula
  version '0.04'
  url "https://github.com/apenwarr/redo/zipball/redo-#{version}"
  homepage 'https://github.com/apenwarr/redo'
  md5 'c4f276f1434d41f1423e25d1fa96e4b8'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
  end
end
