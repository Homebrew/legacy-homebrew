require 'formula'

class Logtalk < Formula
  homepage 'http://logtalk.org'
  url 'http://logtalk.org/files/lgt2432.tar.bz2'
  version '2.43.2'
  md5 'b5698033aca3c5173b7afe0ce4e84782'

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
      head 'https://github.com/pmoura/logtalk.git'
    else
      head 'http://svn.logtalk.org/logtalk/trunk'
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
