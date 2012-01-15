require 'formula'

class Logtalk < Formula
  url 'http://logtalk.org/files/lgt2432.tar.bz2'
  md5 'b5698033aca3c5173b7afe0ce4e84782'
  version '2.43.2'
  homepage 'http://logtalk.org'

  case
  when ARGV.include?("--swi-prolog")
    depends_on 'swi-prolog'
  when ARGV.include?("--gnu-prolog")
    depends_on 'gnu-prolog'
  else
    depends_on 'gnu-prolog'
  end

  case
    when ARGV.include?("--use-git-head")
      head 'git://github.com/pmoura/logtalk.git'
    else
      head 'http://svn.logtalk.org/logtalk/trunk', :using =>   :svn
  end

  def options
     [
       ["--swi-prolog", "Build using SWI Prolog as backend."],
       ["--gnu-prolog", "Build using GNU Prolog as backend. (Default)"],
       ["--use-git-head", "Use GitHub mirror."]
     ]
  end

  def install
    system "scripts/install.sh #{prefix}"
    man1.install Dir['man/man1/*']
    bin.install Dir['bin/*']
  end
end
