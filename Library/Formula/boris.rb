require 'formula'

class Boris < Formula
  homepage 'https://github.com/d11wtq/boris'
  url 'https://github.com/d11wtq/boris.git', :revision => '09c211ab3a79154f39efce542f737ad08596e63f'
  version '09c211ab3a79154f39efce542f737ad08596e63f'

  def install
    prefix.install Dir['*']
  end

  test do
    system 'boris', '-h'
  end

  def caveats
    <<-EOS.undent
    Boris depends on the following PHP features:
      * PHP >= 5.3
      * The Readline functions
      * The PCNTL functions
      * The POSIX functions
    EOS
  end
end
