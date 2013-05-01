require 'formula'

class G2 < Formula
  homepage 'http://orefalo.github.io/g2/'
  url 'https://github.com/orefalo/g2/archive/v1.0.zip'
  sha1 '36e03dca8d44afc1f9b16418ab0deaf093ab45c1'

  head 'https://github.com/orefalo/g2.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
     For Bash, put something like this in your $HOME/.bashrc:
       . #{prefix}/g2-install.sh
     EOS
  end
end
