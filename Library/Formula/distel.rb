require 'formula'

class Distel <Formula
  if ARGV.include? "--dev"
    head 'http://distel.googlecode.com/svn/trunk/'
  else
    url 'http://distel.googlecode.com/files/distel-4.03.tgz'
    md5 '9aea2a15496415653a64db5bc2277519'
  end
  homepage 'http://code.google.com/p/distel/'

  depends_on 'erlang'

  def install
    ENV['prefix'] = prefix
    system "make -e install"
  end
  
  def caveats; <<-EOS
Use a --dev option to install the trunk version of distel.

Ensure that you've set up the erlang elisp package:

  (add-to-list 'load-path "#{HOMEBREW_PREFIX}/lib/erlang/lib/tools-2.6.5/emacs")
  (setq erlang-root-dir "#{HOMEBREW_PREFIX}")
  (require 'erlang-start)

Add the following to your emacs initialization file to set up distel:
    
  (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/distel/elisp")
  (require 'distel)
  (distel-setup)




  
    EOS
  end
end
