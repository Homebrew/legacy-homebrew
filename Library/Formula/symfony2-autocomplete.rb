class Symfony2Autocomplete < Formula
  homepage "https://github.com/KnpLabs/symfony2-autocomplete"
  url "https://github.com/KnpLabs/symfony2-autocomplete/archive/0.1.tar.gz"
  version "0.1"
  sha1 "8f918635978af8b9b96bf6bedd036f2f7f2038f4"

  def install
    bash_completion.install 'symfony2-autocomplete.bash' => 'symfony'
  end


  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile:
      if [ -f $(brew --prefix)/etc/bash_completion.d/symfony ]; then
        . $(brew --prefix)/etc/bash_completion.d/symfony
      fi
    EOS
  end
end
