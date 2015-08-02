require 'formula'

class Psgrep < Formula
  desc "Shortcut for the 'ps aux | grep' idiom"
  homepage 'https://github.com/jvz/psgrep'
  # might be dead soon: https://github.com/jvz/psgrep/issues/2
  url 'https://psgrep.googlecode.com/files/psgrep-1.0.6.tar.bz2'
  sha1 'fe1102546971358a5eff2cff613d70ee63395444'

  head 'https://github.com/jvz/psgrep.git'

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end

  test do
    output = `#{bin}/psgrep #{Process.pid}`
    assert output.include?($0)
    assert_equal 0, $?.exitstatus
  end
end
