require 'formula'

class CpioDownloadStrategy < CurlDownloadStrategy
  def stage
    system "gzcat #{@tarball_path} | cpio -id"
    chdir
  end
end

class Mksh < Formula
  homepage 'https://www.mirbsd.org/mksh.htm'
  url 'https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R40d.cpio.gz',
      :using => CpioDownloadStrategy
  version '0.40d'
  sha1 '74450a1107664797e5fdbdeb444f18f82f0686ac'

  def install
    system 'sh ./Build.sh -combine'
    bin.install 'mksh'
    man1.install 'mksh.1'
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run `chsh` to change their shell.
    EOS
  end
end
