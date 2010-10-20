require 'formula'

class Autojump <Formula
  url 'http://github.com/downloads/joelthelion/autojump/autojump_v12.tar.gz'
  homepage 'http://github.com/joelthelion/autojump/wiki'
  md5 'b12ec5909afef86016d0e9ce7c834071'
  version '12'

  def caveats; <<-EOS
Add the following lines to your ~/.bash_profile file:
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi
    EOS
  end

  def install
    bin.install "autojump"
    man1.install "autojump.1"
    (prefix+'etc').install ["autojump.bash", "autojump.zsh"]
    inreplace "autojump.sh" do |s|
      s.gsub! '/etc/profile.d/', (prefix+'etc/')
    end
    (prefix+'etc').install "autojump.sh" => "autojump"
  end
end
