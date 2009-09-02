require 'brewkit'

class Antiword <Formula
  @url='http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz'
  @homepage='http://www.winfield.demon.nl/'
  @md5='f868e2a269edcbc06bf77e89a55898d1'

  def install
    system 'make'
    bin.install 'antiword'
    man1.install 'Docs/antiword.1'
  end
end
