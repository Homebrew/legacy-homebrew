require 'formula'

class Redo <Formula
  version '0.05'
  url "https://github.com/apenwarr/redo/zipball/redo-#{version}"
  homepage 'https://github.com/apenwarr/redo'
  md5 'e96fe6dbdb75f8512a2ebf62b064186b'

  def install
    ENV['PREFIX'] = prefix
    system "./redo install"
  end
end
