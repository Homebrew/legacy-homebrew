class Jenv < Formula
  desc "Manage your Java environment"
  homepage "http://www.jenv.be"
  url "https://github.com/gcuisinier/jenv/archive/0.4.3.tar.gz"
  sha256 "aa8e5f9da2e89f3c28550bdcc49746b29b14a82ee0b06025dda4a859aa26b69b"
  head "https://github.com/gcuisinier/jenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "799846e7b5e237d148230412214d85e2eadd25b1875eec92f71210994a104db5" => :el_capitan
    sha256 "007fbdb0fdadaff1464c83aff891568a41c7b7c14f4a0db14d129e40df0a88cd" => :yosemite
    sha256 "9099acb01f2dffe6a8051210d1f991c98d062f720d94e47f8a95785d57045245" => :mavericks
    sha256 "89da9b768cc9275abf2a9e5ffd3e06991fcb7d7bd50c7a313debb0e60c904db4" => :mountain_lion
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
   end

  def caveats; <<-EOS.undent
     To enable shims and autocompletion add to your profile:
       if which jenv > /dev/null; then eval "$(jenv init -)"; fi

     To use Homebrew's directories rather than ~/.jenv add to your profile:
       export JENV_ROOT=#{opt_prefix}
     EOS
  end

  test do
    (testpath/".java-version").write "homebrew-test"
    output = `jenv version 2>&1`
    assert output.include? "jenv: version `homebrew-test' is not installed"
  end
end
