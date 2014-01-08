require 'formula'

class Logtalk < Formula
  homepage 'http://logtalk.org'
  url 'http://logtalk.org/files/lgt2432.tar.bz2'
  version '2.43.2'
  sha1 'c5491754f4277c38ecf00d916eb0faba05d58442'

  option "swi-prolog", "Build using SWI Prolog as backend"
  option "gnu-prolog", "Build using GNU Prolog as backend (Default)"
  option "use-git-head", "Use GitHub mirror"

  case
  when build.include?("swi-prolog")
    depends_on 'swi-prolog'
  else
    depends_on 'gnu-prolog'
  end

  case
  when build.include?("use-git-head")
    head 'https://github.com/pmoura/logtalk.git'
  else
    head 'http://svn.logtalk.org/logtalk/trunk'
  end

  def install
    system "scripts/install.sh #{prefix}"
    man1.install Dir['man/man1/*']
    bin.install Dir['bin/*']
  end
end
