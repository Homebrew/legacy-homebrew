require 'formula'

class Rbfu < Formula
  url 'https://github.com/downloads/hmans/rbfu/rbfu-0.2.0.tar.gz'
  homepage 'https://github.com/hmans/rbfu'
  md5 'a7f775ee86923dc2f359ebda5c3e2c44'
  head 'https://github.com/hmans/rbfu.git'

  def install
    prefix.install Dir['*']
  end

  def test
    system "rbfu --help"
  end

  def caveats; <<-EOS.undent
    Please add the following line to your favorite shell startup script:

        eval "$(rbfu --init --auto)"

    If you don't want RVM-like automatic version switching on directory
    changes, remove the --auto option:

        eval "$(rbfu --init)"

    Additional tips & tricks can be found in rbfu's README:

        https://github.com/hmans/rbfu#readme

    Enjoy!

    EOS
  end
end
