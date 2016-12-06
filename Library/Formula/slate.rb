require 'formula'

class Slate < Formula
  homepage 'https://github.com/jigish/slate'
  url 'http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz'
  sha1 '5d32603eb6b663583c01b961941bcb32d391078f'
  version '1.0.25'

  def install
    prefix.install '../Slate.app'
  end

  def caveats; <<-EOS
    Slate.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
