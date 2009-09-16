#!/usr/bin/ruby
require 'global'
require 'formula'
require 'keg'
require 'brew.h'

show_summary_heading = false

def install f  
  build_time = nil

  begin
    f.brew do
      if ARGV.flag? '--interactive'
        ohai "Entering interactive mode"
        puts "Type `exit' to return and finalize the installation"
        puts "Install to this prefix: #{f.prefix}"
        interactive_shell
        nil
      elsif ARGV.include? '--help'
        system './configure --help'
        exit $?
      else
        f.prefix.mkpath
        beginning=Time.now
        f.install
        %w[README ChangeLog COPYING LICENSE COPYRIGHT AUTHORS].each do |file|
          FileUtils.mv "#{file}.txt", file rescue nil
          f.prefix.install file rescue nil
        end
        build_time = Time.now-beginning
      end
    end
  rescue Exception
    if f.prefix.directory?
      f.prefix.rmtree
      f.prefix.parent.rmdir_if_possible
    end
    raise
  end

  if f.caveats
    ohai "Caveats", f.caveats
    show_summary_heading = true
  end

  ohai 'Finishing up' if ARGV.verbose?
  
  begin
    clean f
  rescue Exception => e
    opoo "The cleaning step did not complete successfully"
    puts "Still, the installation was successful, so we will link it into your prefix"
    ohai e, e.inspect if ARGV.debug?
    show_summary_heading = true
  end

  raise "Nothing was installed to #{f.prefix}" unless f.installed?

  # warn the user if stuff was installed outside of their PATH
  paths = ENV['PATH'].split(':').collect{|p| File.expand_path p}
  [f.bin, f.sbin].each do |bin|
    if bin.directory?
      rootbin = (HOMEBREW_PREFIX+bin.basename).to_s
      bin = File.expand_path bin
      unless paths.include? rootbin
        opoo "#{rootbin} is not in your PATH"
        puts "You can amend this by altering your ~/.bashrc file"
        show_summary_heading = true
      end
    end
  end

  begin
    Keg.new(f.prefix).link
  rescue Exception
    onoe "The linking step did not complete successfully"
    puts "The package built, but is not symlinked into #{HOMEBREW_PREFIX}"
    puts "You can try again using `brew link #{f.name}'"
    ohai e, e.inspect if ARGV.debug?
    show_summary_heading = true
  end

  ohai "Summary" if ARGV.verbose? or show_summary_heading
  print "#{f.prefix}: #{f.prefix.abv}"
  print ", built in #{pretty_duration build_time}" if build_time
  puts

rescue Exception => e
  #TODO propogate exception back to brew script
  onoe e
  puts e.backtrace
end


# I like this little at all, but see no alternative seeing as the formula
# rb file has to be the running script to allow it to use __END__ and DATA
at_exit { install(Formula.factory($0)) }
