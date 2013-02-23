require 'formula'

class CpioDownloadStrategy < CurlDownloadStrategy
  def stage
    system "gzcat #{@tarball_path} | cpio -id"
    chdir
  end
end

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'https://mirbsd.org/MirOS/dist/mir/mksh/mksh-R43.tgz'
  version '0.43'
  sha256 '65e54a0cd4189b80cf24fdf1b1b959a707522451025cc22f7d3ba451566ffc81'

  def install
    system "sh", "./Build.sh", "-c", (ENV.compiler == :clang ? "lto" : "combine")
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
