require 'formula'

class FishConflict < Requirement
  def message
    msg = <<-EOS.undent
    Note: fishfish is a fork of the original fish shell and cannot be
    used alongside it.
    EOS
    if !ARGV.force?
      msg << <<-EOS.undent
      You should unlink or uninstall fish first. To install anyway:
        brew install --force fishfish
      EOS
    end

    msg
  end

  def satisfied?
    fish_prefix = Formula.factory('fish').prefix
    not fish_prefix.exist? && Keg.new(fish_prefix).linked?
  end

  def fatal?
    !ARGV.force?
  end
end

class Fishfish < Formula
  homepage 'http://ridiculousfish.com/shell'

  url 'git://github.com/fish-shell/fish-shell.git',
      :tag => 'OpenBeta_r2'
  version 'OpenBeta_r2'

  head 'git://github.com/fish-shell/fish-shell.git',
       :branch => 'master'

  depends_on :autoconf => :build
  depends_on 'doxygen' => :build
  depends_on FishConflict.new

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def test
    system "fish -c 'echo'"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end

