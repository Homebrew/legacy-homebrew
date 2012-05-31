require 'formula'

class WpCli < Formula
  url 'https://github.com/downloads/andreascreten/wp-cli/wp-cli-0.2.zip'
  homepage 'https://github.com/downloads/andreascreten/wp-cli/'
  head 'https://github.com/andreascreten/wp-cli.git'
  md5 '2de14d7f39c746923cf87283f1f31ffb'

  def install
      prefix.install Dir['wp-cli/*']
      # Install bash completion scripts for use with bash-completion
      (prefix+'etc/bash_completion.d').install prefix+'bin/wp-cli-completion.bash' => 'wp'
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
