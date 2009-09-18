require 'brewkit'

def first_dir
  Pathname.getwd.children.find { |d| d.directory? }
end

class Macfuse <Formula
  @head='http://macfuse.googlecode.com/svn/trunk/'
  # This is the original project homepage, but we link to something more useful for OS X users
  #@homepage='http://fuse.sourceforge.net/sshfs.html'
  @homepage='http://code.google.com/p/macfuse/'

  def install
    # the macfuse build system is sadly, shit. Like I know, Mac dev has more
    # steps, especially when integrating with XcodeProj files. But still *I*
    # would have done it properly.
    # Anyway, I've reimplemented it so we get what we want. Sure this is more 
    # maintenance, but surely the point of something like Homebrew is we
    # do it properly for you. Otherwise you may as well just install yourself!
    
    ENV.gcc_4_0_1
    
    ENV['CFLAGS']="#{ENV['CFLAGS']} -arch i386"
    ENV['CXXFLAGS']=ENV['CFLAGS']
    ENV['LDFLAGS']="#{ENV['LDFLAGS']} -arch i386"
    
    Dir.chdir 'core' do
      Dir.chdir '10.5' do
        Dir.chdir 'fusefs' do
          $macfuse_version=`awk '/#define[ \t]*MACFUSE_VERSION_LITERAL/ {print $NF}' common/fuse_version.h`.strip
          
          system "xcodebuild -configuration Release -sdk macosx10.5 ARCHS=i386"
          Dir.chdir 'build/Release' do
            support=Pathname.getwd+'fusefs.fs'+'Support'
            support.install 'fusefs.kext'
            support.install 'load_fusefs'
            support.install 'mount_fusefs'
            (prefix+'Library'+'Filesystems').install 'fusefs.fs'
          end
        end
        Dir.chdir 'libfuse' do
          system "tar xf fuse-current.tar.gz"
          Dir.chdir first_dir do
            system "patch -p1 -i ../fuse-current-macosx.patch"
            save=ENV['CFLAGS']
            ENV['CFLAGS']="#{save} -D__FreeBSD__=10 -D_POSIX_C_SOURCE=200112L -I#{File.expand_path '../../fusefs/common'} -framework CoreFoundation"
            system "./configure --prefix=#{prefix} --disable-dependency-tracking --disable-static"
            system "make install"

            # ffs what a build system!
            Dir.chdir 'lib' do
              system "make clean"
              inreplace 'Makefile', 'libfuse', 'libfuse_ino64'
              inreplace 'Makefile', '-D__FreeBSD__=10', '-D__DARWIN_64_BIT_INO_T=1 -D__FreeBSD__=10'
              system "make install"
            end

            ENV['CFLAGS']=save

            (Dir["#{lib}/*ulockmgr*"]+Dir["#{include}/*ulockmgr*"]).each {|f| File.unlink f}
          end
        end
      end
      Dir.chdir 'sdk-objc' do
        inreplace 'MacFUSE.xcodeproj/project.pbxproj', '${MACFUSE_BUILD_ROOT}/usr/local', prefix
        inreplace 'MacFUSE.xcodeproj/project.pbxproj', '$(MACFUSE_BUILD_ROOT)/usr/local', prefix

        %w[C Objective-C].each do |c|
          inreplace "ProjectTemplates/#{c} Command Line File System/TemplateFS.xcodeproj/project.pbxproj", '/usr/local', prefix
        end
        system "xcodebuild -configuration Release -target MacFUSE-10.5 MACFUSE_BUNDLE_VERSION_LITERAL=#{$macfuse_version} ARCHS=i386"
        (prefix+'Library'+'Frameworks').install Dir['build/Release/*.framework']
      end
    end
  end
  
  def caveats
    <<-EOS
We seriously recommend installing the official MacFuse binary package
available here: http://code.google.com/p/macfuse/

If you still want to use Homebrew's compile you need to do additional steps.
And you absolutely should chown the kext files to root.
    EOS
  end
end
