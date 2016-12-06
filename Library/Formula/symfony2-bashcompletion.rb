require 'formula'

class Symfony2Bashcompletion < Formula
  homepage 'https://github.com/KnpLabs/symfony2-autocomplete'
  url 'https://github.com/KnpLabs/symfony2-autocomplete/tarball/master'
  sha1 'a8de2c13cfe72f1bd78a4d37ececc07322073a6b'
  head 'https://github.com/KnpLabs/symfony2-autocomplete.git'
  version "0.1"

  depends_on 'bash-completion'

  def install
    (prefix+'etc/bash_completion.d').install 'symfony2-autocomplete.bash'
  end
end
