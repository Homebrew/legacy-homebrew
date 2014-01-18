require 'formula'

class Maczfs < Formula
  homepage 'http://MacZFS.org/'
  if MacOS.version < :mavericks
    url 'https://github.com/zfs-osx/zfs.git', :tag => 'zfs-0.6.2'
  end
  head 'https://github.com/zfs-osx/zfs.git', :branch => 'master'

  fails_with :gcc do
    cause "MacZFS must be built with LLVM/Clang"
  end

  if build.head?
    resource 'spl' do
      url 'https://github.com/zfs-osx/spl.git', :branch => 'master'
    end
  else
    resource 'spl' do
      url 'https://github.com/zfs-osx/spl.git', :tag => 'spl-0.6.1'
    end
  end

  def install
    args = ["--prefix=#{prefix}",
            "CC=clang", "CXX=clang++"]
    resource('spl').stage do
      system "./autogen.sh"
      system "./configure", *args
      system "make"
      kext_prefix.install "module/spl/spl.kext"

      spl_dir = Dir.pwd
      cd self.buildpath do
        args << "--with-spl=#{spl_dir}"
        system "./autogen.sh"
        system "./configure", *args

        system "make"
        system "make", "-C", "lib", "install"
        system "make", "-C", "cmd", "install", "DESTDIR=#{prefix}", "prefix=/"
        system "make", "-C", "man", "install"
        system "make", "-C", "scripts", "install"
        kext_prefix.install "module/zfs/zfs.kext"
      end
    end
  end

  def caveats; <<-EOS.undent
    To load the kernel extension issue the following command:

      sudo kextload -r #{kext_prefix} -v #{kext_prefix}/zfs.kext
    EOS
  end
end
