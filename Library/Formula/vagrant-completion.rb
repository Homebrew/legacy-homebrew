require 'formula'

class VagrantCompletion < Formula
  homepage 'https://github.com/kura/vagrant-bash-completion'
  url 'https://github.com/kura/vagrant-bash-completion/tarball/0.0.1'
  sha1 'c114e2bf74e288d397cbc9b7938ddc25c0e628f4'
  head 'https://github.com/kura/vagrant-bash-completion.git'

  def install
    (prefix+'etc/bash_completion.d').install Dir['vagrant']
  end
end
