require 'formula'

class NeedsLion < Requirement
  def satisfied?
    MacOS.lion?
  end
  def message
    "Nu requires Mac OS X 10.7 or newer"
  end
  def fatal?
    true
  end
end

class Nu < Formula
  homepage 'http://programming.nu'
  url 'http://programming.nu/releases/Nu-2.0.1.tgz'
  md5 '8ceee36a3e89cab8d00f543fb61f7ffb'

  depends_on NeedsLion.new
  depends_on 'pcre'

  def install

    ENV['PREFIX'] = prefix

    inreplace "Makefile" do |s|
      cflags = s.get_make_var "CFLAGS"
      s.change_make_var! "CFLAGS", "#{cflags} #{ENV["CPPFLAGS"]}"
    end

    inreplace "Nukefile" do |s|
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
(set @framework_install_path "#{prefix}/Library/Frameworks")
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
    if self.installed? and File.exists? prefix+"Library/Frameworks/Nu.framework"
      return <<-EOS.undent
        Nu.framework was installed to:
          #{prefix}/Library/Frameworks/Nu.framework

        You may want to symlink this Framework to a standard OS X location,
        such as:
          ln -s "#{prefix}/Library/Frameworks/Nu.framework" /Library/Frameworks
      EOS
    end
    return nil
  end
end
