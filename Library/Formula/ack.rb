require 'formula'

class AckCompletion < Formula
  url 'http://github.com/petdance/ack/raw/68120b5d30150e805c033d0458df89a487aa66c5/etc/ack.bash_completion.sh'
  md5 '22e3f388b4fe2b05841ec46b4e1d61b7'
  version '1.92'
end

class Ack < Formula
  url "http://github.com/petdance/ack/raw/079b049b7240c2960a8ff811b2857eba462ad803/ack"
  version '1.92'
  md5 '7db577145ceba9f6cc5fddc3e8198342'
  homepage 'http://betterthangrep.com/'

  def install
    bin.install Dir['*']
    AckCompletion.new.brew { (prefix+'etc/bash_completion.d').install Dir['*'] }
  end
end
