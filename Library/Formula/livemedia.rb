require 'formula'

class Livemedia < Formula
  homepage 'http://www.live555.com/liveMedia/'

  # Mplayer can't link with newer versions of live, so we choose a compatible as default.
  # Also live555 doesn't provide a stable archive link, so we MUST use another source.
  url 'http://live555sourcecontrol.googlecode.com/files/live.2011.12.23.tar.gz'
  sha1 '665b7542da1f719b929d51842f39474ef340d9f6'

  head 'http://www.live555.com/liveMedia/public/live555-latest.tar.gz'

  def install
    system "./genMakefiles", "macosx"
    system "make"

    modules = %w[ groupsock liveMedia BasicUsageEnvironment UsageEnvironment ]

    # Retain the relative directory structure of the source package
    modules.each do |m|
      Dir["#{m}/include/*"].each do |header|
        ( prefix + 'include' + File.dirname(header) ).install header
      end
      Dir["#{m}/*.a"].each do |library|
        ( prefix + 'lib' + File.dirname(library) ).install library
      end
    end

    # Make the include files and libraries available at locations where Mplayer
    # expects to find them.

    # expose the include files at: $(brew --prefix)/include/live
    include.install_symlink( prefix + 'include' => 'live' )

    # expose the libraries at: $(brew --prefix)/lib/live
    lib.install_symlink( prefix + 'lib' => 'live' )
  end

  test do
    src = <<-EOS.undent
      #include "BasicHashTable.hh"
      int main(){
        BasicHashTable* ht = new BasicHashTable(1);
        return 0;
      }
    EOS
    cmd = %W[c++ %s -o %s
                 -I#{include}/live/UsageEnvironment/include
                 -I#{include}/live/BasicUsageEnvironment/include
                 -I#{include}/live/groupsock/include
                 #{lib}/live/BasicUsageEnvironment/libBasicUsageEnvironment.a
                 #{lib}/live/UsageEnvironment/libUsageEnvironment.a  ]

    require 'tempfile'
    Tempfile.open(['test','.cpp']) do |cpp|
      Tempfile.open('test') do |exe|
        cpp.puts src
        cpp.close
        system cmd.join(" ") % [cpp.path, exe.path]
        system 'chmod', '777', exe.path
        system exe.path
      end
    end
  end
end

