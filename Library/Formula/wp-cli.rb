require 'formula'

class WpCli < Formula
  homepage 'https://github.com/andreascreten/wp-cli/'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/andreascreten/wp-cli.git', :tag => 'v0.4.0'
  version '0.4.0'

  head 'https://github.com/andreascreten/wp-cli.git'

  def install
    prefix.install Dir['src/*']
    (prefix+'etc/bash_completion.d').install 'utils/wp-completion.bash' => 'wp'
  end

  def test
    system "#{bin}/wp"
  end
end
