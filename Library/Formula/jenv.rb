class Jenv < Formula
  desc "Manage your Java environment"
  homepage "http://www.jenv.be"
  url "https://github.com/gcuisinier/jenv/archive/0.4.4.tar.gz"
  sha256 "74b48d9c33ceae4e141272c4096086c6ec1a8f10073da379b816518615c79881"
  head "https://github.com/gcuisinier/jenv.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
   end

  def caveats; <<-EOS.undent
     To use Homebrew's directories rather than ~/.jenv add to your profile:
       export JENV_ROOT=#{var}/jenv

     To enable shims and autocompletion add to your profile:
       if which jenv > /dev/null; then eval "$(jenv init -)"; fi
     EOS
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
