class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.25.0.tar.gz"
  sha256 "0583b948f519efaa8fbabd630fae86e2d919c32173fba9ed0db4fcba4640de97"
  head "https://github.com/creationix/nvm.git"

  resource "nvm-exec" do
    url "https://raw.githubusercontent.com/creationix/nvm/v0.24.1/nvm-exec"
    sha256 "915118c666c6f3e03ce4a4545038ecae691c7c496579c614f4d32200a180924c"
  end

  def install
    prefix.install "nvm.sh"
    bash_completion.install "bash_completion" => "nvm"

    resource("nvm-exec").stage do
      prefix.install("nvm-exec")
      chmod 0755, "#{prefix}/nvm-exec"
    end
  end

  def caveats; <<-EOS.undent
      Add NVM's working directory to your $HOME path (if it doesn't exist):

        mkdir ~/.nvm

      Copy nvm-exec to NVM's working directory

        cp $(brew --prefix nvm)/nvm-exec ~/.nvm/

      Add the following to $HOME/.bashrc, $HOME/.zshrc, or your shell's
      equivalent configuration file:

        export NVM_DIR=~/.nvm
        source $(brew --prefix nvm)/nvm.sh

      Type `nvm help` for further information.
    EOS
  end
end
