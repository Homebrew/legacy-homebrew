require 'formula'

# Based on:
# Apple Open Source: http://www.opensource.apple.com/source/cvs/cvs-45/
# MacPorts: https://trac.macports.org/browser/trunk/dports/devel/cvs/Portfile
# Creating a useful testcase: http://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  homepage 'http://cvs.nongnu.org/'
  url 'http://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2'
  sha1 '93a8dacc6ff0e723a130835713235863f1f5ada9'

  keg_only "Xcode (< 5.0) provides CVS" if MacOS::Xcode.provides_cvs?

  def patches
    { :p0 =>
      [ 'http://www.opensource.apple.com/source/cvs/cvs-45/patches/PR5178707.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/ea.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/endian.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/fixtest-client-20.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/fixtest-recase.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/i18n.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/initgroups.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/nopic.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/remove-info.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/remove-libcrypto.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/tag.diff?txt',
        'http://www.opensource.apple.com/source/cvs/cvs-45/patches/zlib.diff?txt'
      ]
    }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--with-gssapi",
                          "--enable-pam",
                          "--enable-encryption",
                          "--with-external-zlib",
                          "--enable-case-sensitivity",
                          "--with-editor=vim",
                          "ac_cv_func_working_mktime=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "mkdir", "cvsroot"

    cvsroot = %x[echo ${PWD}/cvsroot].chomp

    system "#{bin}/cvs", "-d", cvsroot, "init"

    mkdir "cvsexample" do
      ENV['CVSROOT'] = "#{cvsroot}"
      system "#{bin}/cvs", "import", "-m ", "'dir structure'", "cvsexample", "homebrew", "start"
    end
  end
end
