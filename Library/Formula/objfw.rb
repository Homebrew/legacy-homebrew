require 'formula'

class Objfw < Formula
  def options
    [
      ['--no-doc',    "Do not generate docs (or install doxygen)"]
    ]
  end

  url         'http://github.com/aitrus/objfw/tarball/objfw-20101015'
  md5         '4be76757b814b68f5080ea094a54bc6f'
  homepage    'https://webkeks.org/objfw/'

  depends_on  'doxygen' unless ARGV.include? '--no-doc'

  def objfw_script;<<-EOS.undent
      #!/usr/bin/env ruby

      require 'pathname'
      require 'fileutils'

      include FileUtils

      case ARGV.first
      when /inst/     then  puts "Please run the following command, to install ObjFW:"
                            puts "  -> mv #{prefix}/framework/ObjFW.framework /Library/Frameworks/ObjFW.framework"
      when /rem/      then  puts "Please run the following command, to remove ObjFW:"
                            puts "  -> rm -rf /Library/Frameworks/ObjFW.framework"
      when /doc/      then  system "open", "#{prefix}/docs/index.html"
      else                  puts "objfw-brew: commands are 'install-framework-howto', 'remove-framework-howto', 'docs'"
      end
    EOS
  end

  def install
    system  "./autogen.sh"

    system  "./configure", "--prefix=#{prefix}"
    system  "make"
    system  "make", "install"

    unless ARGV.include? '--no-doc'
      system  "doxygen"
      mv      "docs", "#{prefix}/docs"
    end

    system  "xcodebuild"
    mv      "build/Release", "#{prefix}/framework"

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    (bin+"objfw-brew").write objfw_script
  end
end
