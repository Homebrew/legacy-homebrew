require 'formula'

class Nu < Formula
  homepage 'http://programming.nu'
  url 'https://github.com/timburks/nu/archive/v2.1.1.tar.gz'
  sha1 'ca0f9bbd5bbdb8528be516325f274d07d4be54bf'

  depends_on :macos => :lion
  depends_on 'pcre'

  fails_with :llvm do
    build 2336
    cause 'nu only builds with clang'
  end

  fails_with :gcc do
    build 5666
    cause 'nu only builds with clang'
  end

  def install

    ENV['PREFIX'] = prefix

    inreplace "Makefile" do |s|
      cflags = s.get_make_var "CFLAGS"
      s.change_make_var! "CFLAGS", "#{cflags} #{ENV.cppflags}"
      # nu hardcodes its compiler paths to a location which no longer works
      # This should work for both Xcode-only and CLT-only systems
      s.gsub! "$(DEVROOT)/usr/bin/clang", ENV.cc
    end

    inreplace "Nukefile" do |s|
      s.gsub!'"#{DEVROOT}/usr/bin/clang"', "\"#{ENV.cc}\""
      case Hardware.cpu_type
      when :intel
        arch = :i386
      when :ppc
        arch = :ppc
      end
      arch = :x86_64 if arch == :i386 && Hardware.is_64_bit?
      s.sub!(/^;;\(set @arch '\("i386"\)\)$/, "(set @arch '(\"#{arch}\"))") unless arch.nil?
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!('#{@destdir}/Library/Frameworks', '#{@prefix}/Library/Frameworks')
      s.sub! /^;; source files$/, <<-EOS
;; source files
(set @framework_install_path "#{frameworks}")
EOS
    end
    system "make"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats
    if self.installed? and File.exists? frameworks+"Nu.framework"
      return <<-EOS.undent
        Nu.framework was installed to:
          #{frameworks}/Nu.framework

        You may want to symlink this Framework to a standard OS X location,
        such as:
          ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
      EOS
    end
    return nil
  end
end
