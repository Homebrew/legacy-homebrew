require 'formula'

class Direnv < Formula
  url 'https://github.com/zimbatm/direnv/zipball/v0.1.62'
  version '0.1.62'
  md5 'e814487d5036983497a9cc564b29669e'

  head 'git://github.com/zimbatm/direnv.git'
  homepage 'https://github.com/zimbatm/direnv'

  def install
    bin.install Dir['bin/*']
    mkdir_p "#{prefix}/libexec"
    Dir['libexec/*'].each do |exe|
      cp exe, "#{prefix}/libexec"
    end
  end
end
