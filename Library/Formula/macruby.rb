require 'formula'

class Macruby < Formula
  homepage 'https://github.com/MacRuby/MacRuby'
  url 'https://github.com/MacRuby/MacRuby/tarball/0.10'
  md5 '3716da78ec7ff4345bfd1bdaffae5b11'
  head 'https://github.com/MacRuby/MacRuby.git'

  depends_on 'llvm'

  def options
  [
    ["--override-system-ruby", "Override system ruby. Conflicts with ruby Formula."],
    ["--with-doc", "Allow documentation to be generated."]
  ]
  end

  def install
    
    # Skip doc generation
    inreplace 'Rakefile' do |s|
        s.gsub! /, :doc/, ""
    end unless ARGV.include? "--with-doc"

    # 'rake install' does not depend on build
    # so we have to take each step manually.
    #
    # Also, 'rake install' will want to put stuff in '/Developer'
    # and '/Library/Application Support/Developer' regardless
    # of the *_instdir settings. Those are stuff like templates 
    # for XCode. Let's forget about them for now, but
    # we stage the install via DESTDIR and pick the relevant stuff
    # from there.

    # First, build.
    framework_instdir = File.join(prefix, "Frameworks")
    sym_instdir = prefix
    system "rake", "jobs=2", "framework_instdir=#{framework_instdir}", "sym_instdir=#{sym_instdir}"

    # Then, stage the install. At some point it fails if we don't give it 
    # the same *_instdir as for the build phase.
    stage = "#{Dir.pwd}/tmp/stage"
    mkdir_p stage
    system "rake", "install", "framework_instdir=#{framework_instdir}", "sym_instdir=#{sym_instdir}", "DESTDIR=#{stage}"

    # Finally, pick the good parts.
    # Install the framework.
    framework = File.join(framework_instdir, "MacRuby.framework")
    ohai "Installing framework to #{framework_instdir}"
    prefix.install File.join(stage, framework_instdir)

    # 'rake install'-ed bin and share contain broken symlinks to the 
    # framework, built assuming they are in /usr/local and the
    # first occurence of the version is the one from the framework tree.
    # So let's forget about them and use the framework directly.
    framework_prefix = File.join(framework, "Versions/Current/usr")

    bin.mkpath
    bin_dir = File.join(framework_prefix, "bin")
    ohai "Linking binaries from #{bin_dir}"
    Dir[File.join(bin_dir, "*")].each do |f|
        # macruby_select makes no sense in our context
        # llc is provided by llvm Formula
        ln_s f, bin unless ['macruby_select', 'llc'].include? File.basename(f)
    end

    man1.mkpath
    man1_dir = File.join(framework_prefix, "share/man/man1")
    ohai "Linking man pages from #{man1_dir}"
    Dir[File.join(man1_dir, "*.1")].each do |f|
        ln_s f, man1
    end

  end

end
