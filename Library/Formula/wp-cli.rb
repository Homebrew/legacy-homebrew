require 'formula'

class WpCli < Formula
  homepage 'https://github.com/andreascreten/wp-cli/'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/andreascreten/wp-cli.git', :tag => 'v0.4.0'
  version '0.4.0'

  head 'https://github.com/andreascreten/wp-cli.git'

  def install
      prefix.install Dir['src/*']
      # Install bash completion scripts for use with bash-completion
      (prefix+'etc/bash_completion.d').install 'utils/wp-completion.bash' => 'wp'
  end

  def caveats; <<-EOS.undent
    Bash completion script was installed to:
      #{etc}/bash_completion.d/wp
    EOS
  end

  def test
    system "#{bin}/wp"
  end
end
