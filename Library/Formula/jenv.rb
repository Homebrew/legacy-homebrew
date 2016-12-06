require 'formula'


class Jenv < Formula
  homepage 'https://github.com/hikage/jenv'
  url 'https://github.com/hikage/jenv/tarball/0.1.0'
  sha1 '0a5ef6f88a2e22b0b1fde30d87d1a04d59337780'

  def install
     libexec.install Dir['*']
     bin.write_exec_script libexec/'bin/jenv'
   end

   def caveats; <<-EOS.undent
     To enable shims and autocompletion add to your profile:
       if which jenv > /dev/null; then eval "$(jenv init -)"; fi

     To use Homebrew's directories rather than ~/.jenv add to your profile:
       export JENV_ROOT=#{opt_prefix}
     EOS
   end
end
