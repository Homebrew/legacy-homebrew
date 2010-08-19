require 'formula'

def use_default_names?
  ARGV.include? '--default-names'
end

def coreutils_aliases
  s = "brew_prefix=`brew --prefix`\n"

  %w{
    base64 basename cat chcon chgrp chmod chown chroot cksum comm cp csplit
    cut date dd df dir dircolors dirname du echo env expand expr factor false
    fmt fold gropus head hostid id install join kill link ln logname ls md5sum
    mkdir mkfifo mknod mktemp mv nice nl nohup od paste pathchk pinky pr
    printenv printf ptx pwd readlink rm rmdir runcon seq sha1sum sha225sum
    sha256sum sha384sum sha512sum shred shuf sleep sort split stat stty sum
    sync tac tail tee test touch tr true tsort tty uname unexpand uniq unlink
    uptime users vdir wc who whoami yes
    }.each do |g|
    s += "alias #{g}=\"$brew_prefix/bin/g#{g}\"\n"
  end

  s += "alias '['=\"$brew_prefix/bin/g[\""

  return s
end

class Coreutils <Formula
  url "http://ftp.gnu.org/gnu/coreutils/coreutils-8.5.tar.gz"
  md5 'c1ffe586d001e87d66cd80c4536ee823'
  homepage 'http://www.gnu.org/software/coreutils'

  def options
    [
      ['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."],
      ['--aliases', "Dump an aliases file instead of doing the install."]
    ]
  end

  def install
    if ARGV.include? '--aliases'
      puts coreutils_aliases
      exit 0
    end

    args = [ "--prefix=#{prefix}" ]
    args << "--program-prefix=g" unless use_default_names?

    system "./configure", *args
    system "make install"
  end

  def caveats
    unless use_default_names?; <<-EOS
All commands have been installed with the prefix 'g'. In order to use these
commands by default you can put some aliases in your bashrc. You can
accomplish this like so:

    brew install coreutils --aliases >> ~/.bashrc

Please note the manpages are still referenced with the g-prefix.
    EOS
    end
  end
end
