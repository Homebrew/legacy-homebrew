require 'formula'

class Bash <Formula
  url 'http://ftp.gnu.org/gnu/bash/bash-4.1.tar.gz'
  homepage 'http://www.gnu.org/software/bash/'
  sha1 '3bd1ec9c66f3689f6b3495bdaaf9077b2e5dc150'
  version '4.1.7'

  depends_on 'readline'

  def patches
    patch_level = version.split('.').last.to_i
    {'p0' => (1..patch_level).map { |i| "http://ftp.gnu.org/gnu/bash/bash-4.1-patches/bash41-%03d" % i }}
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end

  def caveats
    puts <<-EOS
To use this bash as your standard shell:

    sudo sh -c 'echo `brew --prefix`/bin/bash >> /etc/shells'
    chsh -s "`brew --prefix`/bin/bash"

When uninstalling, please set your shell to the Mac default one:
chsh -s "/bin/bash"
    
    EOS
  end  
end
