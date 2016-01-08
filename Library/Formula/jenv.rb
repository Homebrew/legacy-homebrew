class Jenv < Formula
  desc "Manage your Java environment"
  homepage "http://www.jenv.be"
  url "https://github.com/gcuisinier/jenv/archive/0.4.3.tar.gz"
  sha256 "aa8e5f9da2e89f3c28550bdcc49746b29b14a82ee0b06025dda4a859aa26b69b"
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
