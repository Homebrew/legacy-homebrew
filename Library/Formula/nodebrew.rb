require 'formula'

class Nodebrew < Formula
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.7.3.tar.gz"
  sha1 "df5563d511ddcf662d982346d88eb68334184939"

  def install
    bin.install "nodebrew" => "nodebrew"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew" => "_nodebrew"
    root = ENV['NODEBREW_ROOT'] || "#{ENV['HOME']}/.nodebrew"
    %w[ default/bin node src ].each do |dir|
      mkdir_p "#{root}/#{dir}"
    end
    ln_sf "#{root}/default", "#{root}/current"
  end

  def caveats; <<-EOS.undent
    Add path:
      export PATH=$HOME/.nodebrew/current/bin:$PATH

    To use Homebrew's directories rather than ~/.nodebrew add to your profile:
      export NODEBREW_ROOT=/usr/local/var/nodebrew
    EOS
  end

  test do
    system "#{bin}/nodebrew", 'help'
  end

end
