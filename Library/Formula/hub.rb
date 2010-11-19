require 'formula'

class Hub <Formula
  url 'https://github.com/defunkt/hub/tarball/v1.4.1'
  homepage 'https://github.com/defunkt/hub'
  md5 '0b62ab79ac10962cab08bdb47c9f9d34'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
