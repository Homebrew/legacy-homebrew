require 'formula'

class Cpanminus <Formula
  head 'git://github.com/miyagawa/cpanminus.git'
  homepage 'https://github.com/miyagawa/cpanminus'

  def install
    bin.install ['cpanm']
  end
end
