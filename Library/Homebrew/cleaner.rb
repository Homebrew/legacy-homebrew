class Cleaner
  def initialize f
    @f=f
    [f.bin, f.sbin, f.lib].select{|d|d.exist?}.each{|d|clean_dir d}

    unless ENV['HOMEBREW_KEEP_INFO'].nil?
      f.info.rmtree if f.info.directory? and not f.skip_clean? f.info
    end
  end

private
  def strip path, args=''
    return if @f.skip_clean? path
    puts "strip #{path}" if ARGV.verbose?
    path.chmod 0644 # so we can strip
    unless path.stat.nlink > 1
      system "strip", *(args+path)
    else
      path = path.to_s.gsub ' ', '\\ '

      # strip unlinks the file and recreates it, thus breaking hard links!
      # is this expected behaviour? patch does it too… still, this fixes it
      tmp = `/usr/bin/mktemp -t homebrew_strip`.chomp
      begin
        `/usr/bin/strip #{args} -o #{tmp} #{path}`
        `/bin/cat #{tmp} > #{path}`
      ensure
        FileUtils.rm tmp
      end
    end
  end

  def clean_file path
    perms=0444
    case `file -h '#{path}'`
    when /Mach-O dynamically linked shared library/
      # Stripping libraries is causing no end of trouble
      # Lets just give up, and try to do it manually in instances where it
      # makes sense
      #strip path, '-SxX'
    when /Mach-O [^ ]* ?executable/
      strip path
      perms=0555
    when /script text executable/
      perms=0555
    end
    path.chmod perms
  end

  def clean_dir d
    d.find do |path|
      if path.directory?
        Find.prune if @f.skip_clean? path
      elsif not path.file?
        next
      elsif path.extname == '.la' and not @f.skip_clean? path
        # *.la files are stupid
        path.unlink
      elsif not path.symlink?
        clean_file path
      end
    end
  end
end
