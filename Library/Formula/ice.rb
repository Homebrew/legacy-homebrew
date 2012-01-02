require 'formula'

class Ice < Formula
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.1.tar.gz'
  homepage 'http://www.zeroc.com'
  md5 '3aae42aa47dec74bb258c1a1b2847a1a'

  depends_on 'berkeley-db'
  depends_on 'mcpp'

  def patches
    # Patch for Ice-3.4.1 to work with Berkely DB 5.X.
    "http://gist.github.com/raw/459204/44183ae997afb8ec19148fec498a11d67b5ae8bf/Ice-3.4.1-db5.patch"
  end

  def options
    [
      ['--doc', 'Install documentation'],
      ['--demo', 'Build demos']
    ]
  end

  def install
    ENV.O2
    inreplace "cpp/config/Make.rules" do |s|
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
      s.gsub! "/opt/Ice-$(VERSION)", prefix
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
    end

    # what want we build?
    wb = 'config src include'
    wb += ' doc' if ARGV.include? '--doc'
    wb += ' demo' if ARGV.include? '--demo'
    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    inreplace "cpp/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -Wall -D_REENTRANT"
    end

    Dir.chdir "cpp" do
      system "make"
      system "make install"
    end
  end
end
