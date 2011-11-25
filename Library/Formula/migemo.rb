require 'formula'

class Migemo < Formula
  url 'http://0xcc.net/migemo/migemo-0.40.tar.gz'
  homepage 'http://0xcc.net/migemo/'
  md5 '7021c45096b6816fccf16f8389324a91'

  depends_on 'emacs'
  depends_on 'ruby-bsearch'
  depends_on 'ruby-romkan'

  def install
    ENV['RUBYLIB'] = "#{HOMEBREW_PREFIX}/lib/ruby";
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-rubydir=#{prefix}/lib/ruby"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To export the needed variable, add this to your dotfiles.
     * On Bash, add this to `~/.bash_profile`.
     * On Zsh, add this to `~/.zprofile` instead.
    export RUBYLIB=#{HOMEBREW_PREFIX}/lib/ruby

    To export the needed expression, add this to your `~/.emacs`.
    (require 'migemo)
    EOS
  end
end
