require 'formula'

class PhpInstall < Formula
  homepage 'https://github.com/marcosdsanchez/php-install#readme'
  url 'https://github.com/marcosdsanchez/php-install/archive/v0.0.1.tar.gz'
  sha1 '7306700d7963e24bb670b37e1de5613483df24f4'

  head 'https://github.com/marcosdsanchez/php-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
